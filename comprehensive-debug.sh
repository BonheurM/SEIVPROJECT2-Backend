#!/bin/bash

echo "========================================"
echo "COMPREHENSIVE DEBUG SCRIPT - TEAM 2"
echo "========================================"
echo "Run this script on the production server to diagnose issues"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== 1. CHECKING DIRECTORY AND FILES ===${NC}"
echo "Current directory: $(pwd)"
echo "Expected directory: /home/ubuntu/nodeapps/2025/project2/t2"
echo ""
echo "Checking if we're in the right directory:"
if [ -d "/home/ubuntu/nodeapps/2025/project2/t2" ]; then
    echo -e "${GREEN}✓ Directory exists${NC}"
    cd /home/ubuntu/nodeapps/2025/project2/t2
    echo "Contents:"
    ls -la | head -20
else
    echo -e "${RED}✗ Directory not found!${NC}"
fi

echo -e "\n${YELLOW}=== 2. CHECKING SERVICE STATUS ===${NC}"
sudo systemctl status course-t2-backend.service --no-pager -l
echo ""
echo "Service file location:"
ls -la /lib/systemd/system/course-t2-backend.service

echo -e "\n${YELLOW}=== 3. CHECKING .ENV FILE ===${NC}"
if [ -f .env ]; then
    echo -e "${GREEN}✓ .env file exists${NC}"
    echo "Environment variables (sensitive values hidden):"
    while IFS='=' read -r key value; do
        if [[ ! -z "$key" && ! "$key" =~ ^[[:space:]]*# ]]; then
            if [[ "$key" =~ (PASSWORD|PW|SECRET|KEY) ]]; then
                echo "$key=***HIDDEN***"
            else
                echo "$key=$value"
            fi
        fi
    done < .env
else
    echo -e "${RED}✗ .env file not found!${NC}"
fi

echo -e "\n${YELLOW}=== 4. CHECKING NODE AND NPM ===${NC}"
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "Checking if package.json exists:"
if [ -f package.json ]; then
    echo -e "${GREEN}✓ package.json exists${NC}"
    echo "Start script:"
    grep -A 2 '"scripts"' package.json | grep "start"
else
    echo -e "${RED}✗ package.json not found!${NC}"
fi

echo -e "\n${YELLOW}=== 5. CHECKING PORT 3012 ===${NC}"
echo "Checking if anything is listening on port 3012:"
sudo netstat -tlnp | grep 3012 || echo "Nothing listening on port 3012"

echo -e "\n${YELLOW}=== 6. CHECKING SERVICE LOGS ===${NC}"
echo "Last 30 lines of service logs:"
sudo journalctl -u course-t2-backend.service -n 30 --no-pager

echo -e "\n${YELLOW}=== 7. TESTING DATABASE CONNECTION ===${NC}"
cat > test-connection.js << 'EOF'
require('dotenv').config();
const mysql = require('mysql2');

console.log('Testing database connection...');
console.log('DB_HOST:', process.env.DB_HOST || 'NOT SET');
console.log('DB_USER:', process.env.DB_USER || 'NOT SET');
console.log('DB_NAME:', process.env.DB_NAME || 'NOT SET');
console.log('DB_PORT:', process.env.DB_PORT || '3306');

if (!process.env.DB_HOST) {
    console.error('ERROR: DB_HOST is not set!');
    process.exit(1);
}

const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PW,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 3306
});

connection.connect((err) => {
    if (err) {
        console.error('Database connection failed:', err.message);
        console.error('Error code:', err.code);
        console.error('Error errno:', err.errno);
    } else {
        console.log('Database connection successful!');
        connection.end();
    }
    process.exit(err ? 1 : 0);
});
EOF

node test-connection.js
rm test-connection.js

echo -e "\n${YELLOW}=== 8. TESTING MANUAL START ===${NC}"
echo "Trying to start the service manually:"
timeout 10 npm run start || echo -e "${RED}Manual start failed or timed out${NC}"

echo -e "\n${YELLOW}=== 9. CHECKING APACHE PROXY ===${NC}"
echo "Looking for Apache configuration:"
sudo grep -r "course-t2" /etc/apache2/sites-available/ 2>/dev/null || echo "No Apache config found for course-t2"
sudo grep -r "3012" /etc/apache2/sites-available/ 2>/dev/null || echo "No Apache config found for port 3012"

echo -e "\n${YELLOW}=== 10. TESTING LOCALHOST ===${NC}"
echo "Testing if backend responds on localhost:"
curl -s http://localhost:3012/course-t2/health -w "\nHTTP Status: %{http_code}\n" || echo "Failed to connect to localhost:3012"

echo -e "\n${YELLOW}=== 11. CHECKING DEPENDENCIES ===${NC}"
echo "Checking if node_modules exists:"
if [ -d node_modules ]; then
    echo -e "${GREEN}✓ node_modules exists${NC}"
    echo "Number of packages: $(ls node_modules | wc -l)"
else
    echo -e "${RED}✗ node_modules not found!${NC}"
    echo "Running npm install..."
    npm install
fi

echo -e "\n${YELLOW}=== 12. PERMISSION CHECK ===${NC}"
echo "Checking file permissions:"
ls -la server.js package.json .env 2>/dev/null

echo -e "\n${YELLOW}=== SUMMARY OF ISSUES ===${NC}"
echo "Common issues to check:"
echo "1. If DB_HOST is 'NOT SET' - Add it to GitHub Secrets"
echo "2. If service won't start - Check the service logs above"
echo "3. If 'Nothing listening on port 3012' - Service is not running"
echo "4. If Apache config not found - Apache proxy needs configuration"
echo "5. If database connection fails - Check DB_HOST and credentials"
echo ""
echo "To fix most issues:"
echo "1. Ensure all GitHub secrets are set (especially DB_HOST)"
echo "2. Re-run the GitHub Actions deployment"
echo "3. If Apache proxy missing, contact server admin"