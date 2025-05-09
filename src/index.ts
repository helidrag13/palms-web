import express from 'express';
import { config } from './config/index.js';
import { authMiddleware } from './auth/middleware.js';
import routes from './routes/index.js';
import { createLogger } from './utils/logger.js';

const logger = createLogger();
const app = express();

// Auth0 middleware
app.use(authMiddleware);
// Parse JSON
app.use(express.json());
// Application routes including /time
app.use(routes);

app.listen(config.port, () => {
  logger.info(`App running at ${config.baseURL}`);
});


/*** 
 * 
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
}); */