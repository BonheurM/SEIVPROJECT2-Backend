// Production course import script
require('dotenv').config();
const fs = require('fs');
const csv = require('csv-parser');
const { Sequelize } = require('sequelize');

// Production database configuration
const sequelize = new Sequelize(
  process.env.DB_NAME || 'course-t2',
  process.env.DB_USER || 't22025', 
  process.env.DB_PW || 'CS@oc2025t2',
  {
    host: process.env.DB_HOST || 't2-database.czjofbims6cw.us-west-2.rds.amazonaws.com',
    port: process.env.DB_PORT || 3306,
    dialect: 'mysql',
    logging: console.log
  }
);

// Import the model
const Course = require('./app/models/course.model.js')(sequelize, Sequelize);

async function importCourses() {
  try {
    // Test connection
    await sequelize.authenticate();
    console.log('✅ Database connected successfully');
    
    // Sync the model
    await Course.sync();
    console.log('✅ Course table ready');
    
    // Check if courses already exist
    const count = await Course.count();
    if (count > 0) {
      console.log(`⚠️  Database already has ${count} courses. Skipping import.`);
      return;
    }
    
    // Read the CSV file
    const courses = [];
    const csvPath = process.env.CSV_PATH || '/Users/jonathanmuhire/Downloads/courses.csv';
    
    console.log(`📖 Reading courses from: ${csvPath}`);
    
    await new Promise((resolve, reject) => {
      fs.createReadStream(csvPath)
        .pipe(csv())
        .on('data', (row) => {
          courses.push({
            dept: row.dept,
            courseNumber: `${row.dept}-${row.num}`,
            level: parseInt(row.level) || 0,
            hours: parseFloat(row.hours) || 0,
            name: row.name,
            description: row.description || ''
          });
        })
        .on('end', resolve)
        .on('error', reject);
    });
    
    console.log(`📊 Found ${courses.length} courses to import`);
    
    // Bulk create in batches
    const batchSize = 100;
    for (let i = 0; i < courses.length; i += batchSize) {
      const batch = courses.slice(i, i + batchSize);
      await Course.bulkCreate(batch);
      console.log(`✅ Imported ${Math.min(i + batchSize, courses.length)} / ${courses.length} courses`);
    }
    
    console.log('🎉 Course import completed successfully!');
    
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await sequelize.close();
  }
}

// Run if called directly
if (require.main === module) {
  importCourses();
}

module.exports = importCourses;