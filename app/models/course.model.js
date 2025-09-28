module.exports = (sequelize, Sequelize) => {
  const Course = sequelize.define("course", {
    dept: {
      type: Sequelize.STRING,
      allowNull: false
    },
    courseNumber: {
      type: Sequelize.STRING,
      allowNull: false
    },
    level: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    hours: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false
    },
    description: {
      type: Sequelize.TEXT
    }
  });

  return Course;
};