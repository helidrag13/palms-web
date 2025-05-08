import { Pool } from 'pg';
import { config } from '../config';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

export const getCurrentDbTime = async (): Promise<string> => {
  const result = await pool.query('SELECT NOW()');
  return result.rows[0].now;
};