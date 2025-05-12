const express = require('express');
const routes = require('./routes');

const app = express();

// Middleware
app.use(express.json());


// API Routes
app.use('/api/v1', routes);

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
});

module.exports = app;