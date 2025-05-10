// src/routes/api/v1/skill.routes.js
const express = require('express');
const router = express.Router();

const skillController = require('../../../controllers/skill.controller');

router.get('/', skillController.getAllSkills);

module.exports = router;
