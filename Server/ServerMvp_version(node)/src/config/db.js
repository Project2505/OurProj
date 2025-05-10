
const { Pool } = require('pg');

const pool = new Pool({
  host: 'dpg-d0fk1mqdbo4c73ahsv50-a.oregon-postgres.render.com',
  port: 5432,
  database: 'squadup',
  user: 'squadup_user',
  password: 'F7p6fV1u5J1Z0HxVjDjXGr0ZWy8zP4TK',
  ssl: true,
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};