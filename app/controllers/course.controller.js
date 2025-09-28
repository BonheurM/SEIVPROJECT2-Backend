const db = require("../models");
const Course = db.courses;
const Op = db.Sequelize.Op;

// Create and Save a new Course
exports.create = (req, res) => {
  // Validate request
  if (!req.body.dept || !req.body.courseNumber || !req.body.name) {
    res.status(400).send({
      message: "Department, course number, and name are required!"
    });
    return;
  }

  // Create a Course
  const course = {
    dept: req.body.dept,
    courseNumber: req.body.courseNumber,
    level: req.body.level || 0,
    hours: req.body.hours || 0,
    name: req.body.name,
    description: req.body.description
  };

  // Save Course in the database
  Course.create(course)
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Course."
      });
    });
};

// Retrieve all Courses with optional filters
exports.findAll = (req, res) => {
  const { dept, level, search, minLevel, maxLevel, limit } = req.query;
  let condition = {};

  // Add department filter
  if (dept) {
    condition.dept = dept;
  }

  // Add level filter
  if (level) {
    condition.level = level;
  }

  // Add level range filter
  if (minLevel && maxLevel) {
    condition.level = {
      [Op.between]: [parseInt(minLevel), parseInt(maxLevel)]
    };
  }

  // Add search functionality for course name, number, or department
  if (search) {
    condition[Op.or] = [
      { name: { [Op.like]: `%${search}%` } },
      { courseNumber: { [Op.like]: `%${search}%` } },
      { description: { [Op.like]: `%${search}%` } },
      { dept: { [Op.like]: `%${search}%` } }
    ];
  }

  Course.findAll({ 
    where: condition,
    order: [['dept', 'ASC'], ['courseNumber', 'ASC']],
    limit: limit ? parseInt(limit) : 500
  })
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving courses."
      });
    });
};

// Find a single Course with an id
exports.findOne = (req, res) => {
  const id = req.params.id;

  Course.findByPk(id)
    .then(data => {
      if (data) {
        res.send(data);
      } else {
        res.status(404).send({
          message: `Cannot find Course with id=${id}.`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Error retrieving Course with id=" + id
      });
    });
};

// Update a Course by the id in the request
exports.update = (req, res) => {
  const id = req.params.id;

  Course.update(req.body, {
    where: { id: id }
  })
    .then(num => {
      if (num == 1) {
        res.send({
          message: "Course was updated successfully."
        });
      } else {
        res.send({
          message: `Cannot update Course with id=${id}. Maybe Course was not found or req.body is empty!`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Error updating Course with id=" + id
      });
    });
};

// Delete a Course with the specified id in the request
exports.delete = (req, res) => {
  const id = req.params.id;

  Course.destroy({
    where: { id: id }
  })
    .then(num => {
      if (num == 1) {
        res.send({
          message: "Course was deleted successfully!"
        });
      } else {
        res.send({
          message: `Cannot delete Course with id=${id}. Maybe Course was not found!`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Could not delete Course with id=" + id
      });
    });
};

// Get all unique departments
exports.getDepartments = (req, res) => {
  Course.findAll({
    attributes: [[db.Sequelize.fn('DISTINCT', db.Sequelize.col('dept')), 'dept']],
    order: [['dept', 'ASC']]
  })
    .then(data => {
      res.send(data.map(d => d.dept));
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Error retrieving departments."
      });
    });
};