import express from 'express';
import { Pool } from 'pg';

const app = express();
const PORT = process.env.PORT || 3000;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

app.get('/', async (_req, res) => {
  const result = await pool.query('SELECT NOW()');
  res.send(`¡Hola! La base de datos responde: ${result.rows[0].now}`);
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});