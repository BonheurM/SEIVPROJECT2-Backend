#!/bin/bash

echo "=== Team 2 Backend Debug Script ==="
echo

echo "1. Checking service status:"
sudo systemctl status course-backend-t2 --no-pager

echo -e "\n2. Checking service logs (last 50 lines):"
sudo journalctl -u course-backend-t2 -n 50 --no-pager

echo -e "\n3. Checking if process is running:"
ps aux | grep node | grep -v grep

echo -e "\n4. Checking if port 3012 is listening:"
sudo lsof -i :3012

echo -e "\n5. Checking environment file:"
if [ -f /home/ubuntu/nodeapps/2025/project2/t2/.env ]; then
    echo ".env file exists"
    echo "Contents (without passwords):"
    grep -E "^(DB_HOST|DB_USER|DB_NAME|PORT|BASE_PATH)" /home/ubuntu/nodeapps/2025/project2/t2/.env
else
    echo ".env file NOT FOUND!"
fi

echo -e "\n6. Testing database connection:"
cd /home/ubuntu/nodeapps/2025/project2/t2
node -e "
const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: process.env.DB_HOST || 't2-database.czjofbims6cw.us-west-2.rds.amazonaws.com',
  user: process.env.DB_USER || 't22025',
  password: process.env.DB_PW || 'CS@oc2025t2',
  database: process.env.DB_NAME || 'course-t2',
  port: 3306
});
connection.connect((err) => {
  if (err) {
    console.error('Database connection FAILED:', err.message);
  } else {
    console.log('Database connection SUCCESSFUL!');
    connection.query('SELECT COUNT(*) as count FROM courses', (err, results) => {
      if (err) {
        console.error('Query failed:', err.message);
      } else {
        console.log('Number of courses in database:', results[0].count);
      }
      connection.end();
    });
  }
});
"

echo -e "\n7. Checking Apache proxy configuration:"
grep -r "course-t2" /etc/apache2/sites-enabled/ 2>/dev/null || echo "No proxy config found"

echo -e "\n=== Debug complete ==="