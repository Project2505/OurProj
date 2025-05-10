
const express = require('express');
const router = express.Router();


const skillRoutes = require('./api/v1/skill.routes');


router.use('/v1/skills', skillRoutes); 

module.exports = router;
