// src/app.js
const express = require('express');
const routes = require('./routes');
const errorMiddleware = require('./middleware/error.middlewaer');

const app = express();

// Middleware
app.use(express.json());

// API Routes
app.use('/api', routes);

// Error handler
app.use(errorMiddleware);

module.exports = app;