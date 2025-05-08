import { Router } from 'express';
import { getCurrentDbTime } from '../db/client';

const router = Router();

router.get('/time', async (_req, res, next) => {
  try {
    const now = await getCurrentDbTime();
    res.json({ time: now });
  } catch (err) {
    next(err);
  }
});

export default router;