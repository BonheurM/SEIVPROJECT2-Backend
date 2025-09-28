module.exports = app => {
  const courses = require("../controllers/course.controller.js");
  var router = require("express").Router();

  // Create a new Course
  router.post("/", courses.create);

  // Retrieve all Courses
  router.get("/", courses.findAll);

  // Get all departments
  router.get("/departments", courses.getDepartments);

  // Retrieve a single Course with id
  router.get("/:id", courses.findOne);

  // Update a Course with id
  router.put("/:id", courses.update);

  // Delete a Course with id
  router.delete("/:id", courses.delete);

  app.use('/api/courses', router);
};