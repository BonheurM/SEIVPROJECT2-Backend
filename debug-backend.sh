#!/bin/bash

echo "=== Team 2 Backend Debug Script ==="
echo "Run this on the production server to troubleshoot issues"
echo ""

echo "1. Checking service status:"
sudo systemctl status course-t2-backend.service --no-pager -l

echo -e "\n2. Checking if service file exists:"
ls -la /lib/systemd/system/course-t2-backend.service

echo -e "\n3. Checking backend directory:"
ls -la ~/nodeapps/2025/project2/t2/

echo -e "\n4. Checking .env file (without showing secrets):"
if [ -f ~/nodeapps/2025/project2/t2/.env ]; then
    echo ".env file exists"
    grep -E "^(PORT|BASE_PATH|DB_NAME|DB_HOST)" ~/nodeapps/2025/project2/t2/.env | sed 's/=.*/=***/'
else
    echo ".env file NOT FOUND!"
fi

echo -e "\n5. Checking if Node.js process is running:"
ps aux | grep -E "node.*server.js|course-t2" | grep -v grep

echo -e "\n6. Checking port 3012:"
sudo netstat -tlnp | grep 3012 || echo "Port 3012 not in use"

echo -e "\n7. Checking service logs:"
sudo journalctl -u course-t2-backend.service -n 50 --no-pager

echo -e "\n8. Testing localhost connection:"
curl -s http://localhost:3012/course-t2/health || echo "Failed to connect to localhost:3012"

echo -e "\n9. Checking Apache proxy configuration:"
sudo grep -r "course-t2" /etc/apache2/sites-available/ || echo "No Apache config found for course-t2"

echo -e "\n10. Database connection test:"
cd ~/nodeapps/2025/project2/t2 && node -e "
require('dotenv').config();
console.log('DB Config (censored):');
console.log('DB_HOST:', process.env.DB_HOST ? 'Set' : 'NOT SET');
console.log('DB_USER:', process.env.DB_USER ? 'Set' : 'NOT SET');
console.log('DB_PW:', process.env.DB_PW ? 'Set' : 'NOT SET');
console.log('DB_NAME:', process.env.DB_NAME || 'NOT SET');
console.log('DB_PORT:', process.env.DB_PORT || '3306');
"

echo -e "\n=== Debug Summary ==="
echo "Key things to verify:"
echo "1. DB_NAME should be 'course-t2' (not t22025)"
echo "2. Service should be running on port 3012"
echo "3. Apache should proxy /course-t2 to localhost:3012/course-t2"
echo "4. All environment variables should be set in .env file"