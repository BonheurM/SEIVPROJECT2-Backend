const mysql = require('mysql2');

// Test database connection
const testConnection = async () => {
  const hosts = [
    'localhost',
    '127.0.0.1',
    'project2.eaglesoftwareteam.com',
    't2-database.czjofbims6cw.us-west-2.rds.amazonaws.com'
  ];

  for (const host of hosts) {
    console.log(`\nTesting connection to ${host}...`);
    
    const connection = mysql.createConnection({
      host: host,
      user: 't22025',
      password: 'CS@oc2025t2',
      database: 'course-t2',
      port: 3306,
      connectTimeout: 5000
    });

    try {
      await new Promise((resolve, reject) => {
        connection.connect(err => {
          if (err) reject(err);
          else resolve();
        });
      });
      
      console.log(`✅ SUCCESS! DB_HOST should be: ${host}`);
      connection.end();
      return;
      
    } catch (error) {
      console.log(`❌ Failed: ${error.message}`);
      connection.destroy();
    }
  }
  
  console.log('\n❌ Could not connect to any host. Contact instructor.');
};

testConnection();