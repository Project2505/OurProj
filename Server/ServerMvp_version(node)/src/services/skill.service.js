
const { query } = require('../config/db');

exports.getAllSkills = async () => {
  const result = await query('SELECT * FROM Skills');
  return result.rows;
};