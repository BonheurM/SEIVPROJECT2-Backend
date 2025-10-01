module.exports = (sequelize, Sequelize) => {
  const Course = sequelize.define("course", {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    dept: {
      type: Sequelize.STRING,
      allowNull: false,
      field: 'Dept'
    },
    courseNumber: {
      type: Sequelize.STRING,
      allowNull: false,
      field: 'Course Number'
    },
    level: {
      type: Sequelize.INTEGER,
      allowNull: false,
      field: 'Level'
    },
    hours: {
      type: Sequelize.INTEGER,
      allowNull: false,
      field: 'Hours'
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false,
      field: 'Name'
    },
    description: {
      type: Sequelize.TEXT,
      field: 'Description'
    }
  }, {
    tableName: 'courses',
    timestamps: false
  });

  return Course;
};