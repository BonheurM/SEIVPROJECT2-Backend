require("dotenv").config();
const fs = require('fs');
const csv = require('csv-parser');
const db = require("./app/models");

// Path to the CSV file
const CSV_PATH = '/Users/jonathanmuhire/Downloads/courses.csv';

async function importCourses() {
  try {
    // Wait for database connection
    await db.sequelize.authenticate();
    console.log('Database connected.');

    const courses = [];
    
    // Read and parse CSV
    fs.createReadStream(CSV_PATH)
      .pipe(csv())
      .on('data', (row) => {
        // Skip rows with empty or invalid data
        if (row.Dept && row['Course Number'] && row.Name) {
          courses.push({
            dept: row.Dept,
            courseNumber: row['Course Number'],
            level: parseInt(row.Level) || 0,
            hours: parseInt(row.Hours) || 0,
            name: row.Name,
            description: row.Description || ''
          });
        }
      })
      .on('end', async () => {
        console.log(`Found ${courses.length} valid courses to import`);
        
        // Import in batches of 50
        const batchSize = 50;
        for (let i = 0; i < courses.length; i += batchSize) {
          const batch = courses.slice(i, i + batchSize);
          try {
            await db.courses.bulkCreate(batch);
            console.log(`Imported batch ${Math.floor(i/batchSize) + 1} of ${Math.ceil(courses.length/batchSize)}`);
          } catch (error) {
            console.error(`Error importing batch: ${error.message}`);
          }
        }
        
        console.log('Import completed!');
        process.exit(0);
      });
      
  } catch (error) {
    console.error('Import failed:', error);
    process.exit(1);
  }
}

// Run the import
importCourses();