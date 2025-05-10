// src/routes/index.js
const express = require('express');
const router = express.Router();

// Импортируем маршруты напрямую
const skillRoutes = require('./api/v1/skill.routes');

// Регистрируем маршруты
router.use('/v1/skills', skillRoutes); // ← теперь здесь указан полный путь

module.exports = router;