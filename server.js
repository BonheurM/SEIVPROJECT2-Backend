require("dotenv").config();

const express = require("express");
const cors = require("cors");
const app = express();

// CORS configuration for both development and production
const corsOptions = {
  origin: process.env.NODE_ENV === "production" 
    ? ["https://project2.eaglesoftwareteam.com", "http://localhost:8081"]
    : "http://localhost:8081",
  credentials: true
};
app.use(cors(corsOptions));
// parse requests of content-type - application/json
app.use(express.json());
// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));
// set up database 
const db = require("./app/models");
// for not to recreate each time database but add new things
 db.sequelize.sync();
// for devel to recreate each time database 
//db.sequelize.sync({ force: true }).then(() => {
//   console.log("Drop and re-sync db.");
//});
// Handle BASE_PATH for production deployment
const BASE_PATH = process.env.BASE_PATH || "";

// Create router for API routes
const apiRouter = express.Router();

// simple route
apiRouter.get("/", (req, res) => {
  res.json({ message: "Oklahoma Christian University Course Catalog API" });
});

// Health check endpoint for AWS
apiRouter.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy", timestamp: new Date().toISOString() });
});

// Apply routes to router
require("./app/routes/tutorial.routes")(apiRouter);
require("./app/routes/lesson.routes")(apiRouter);
require("./app/routes/course.routes")(apiRouter);

// Mount router with base path
app.use(BASE_PATH, apiRouter);
// set port, listen for requests
const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});