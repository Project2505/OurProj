const { query } = require('../config/db');

exports.getAllSkills = async () => {
  const result = await query('SELECT * FROM Skills');
  return result.rows;
};

exports.getSkillById = async (id) => {
  const result = await query('SELECT * FROM Skills WHERE SkillID = $1', [id]);
  return result.rows[0];
};