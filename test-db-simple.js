require('dotenv').config();
const mysql = require('mysql2');

console.log('=== Database Connection Test ===');
console.log('DB_HOST:', process.env.DB_HOST || 'NOT SET');
console.log('DB_USER:', process.env.DB_USER || 'NOT SET');
console.log('DB_PW:', process.env.DB_PW ? '***SET***' : 'NOT SET');
console.log('DB_NAME:', process.env.DB_NAME || 'NOT SET');
console.log('DB_PORT:', process.env.DB_PORT || '3306');

if (!process.env.DB_HOST) {
  console.error('\nERROR: DB_HOST is not set in environment variables!');
  console.error('This is likely why the service is failing.');
  console.error('\nTo fix this:');
  console.error('1. Check GitHub Secrets - make sure DB_HOST is set');
  console.error('2. DB_HOST should be something like: xxxx.rds.amazonaws.com');
  console.error('3. Ask your instructor for the correct RDS endpoint');
  process.exit(1);
}

// Try to create a connection
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PW,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306
});

console.log('\nAttempting to connect...');

connection.connect((err) => {
  if (err) {
    console.error('\nConnection failed!');
    console.error('Error code:', err.code);
    console.error('Error message:', err.message);
    
    if (err.code === 'ENOTFOUND') {
      console.error('\nThis error means the database host cannot be found.');
      console.error('Likely causes:');
      console.error('1. DB_HOST is incorrect or not set');
      console.error('2. The RDS instance is not accessible');
      console.error('3. Network/DNS issues');
    }
  } else {
    console.log('\nConnection successful!');
    connection.end();
  }
  process.exit(err ? 1 : 0);
});