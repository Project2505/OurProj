const express = require('express');
const router = express.Router();


try {
  const skillController = require('../../../controllers/skill.controller');

  router.get('/', skillController.getAllSkills);
  router.get('/:id', skillController.getSkillById);

} catch (err) {
  console.error('Controller load error:', err);
}

module.exports = router;