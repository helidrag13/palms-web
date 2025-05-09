import { Router } from 'express';
import authRoutes from './auth.js';
import profileRoutes from './profile.js';
import timeRoutes from './time.js';

const router = Router();

router.use(authRoutes);
router.use(profileRoutes);
router.use(timeRoutes);

export default router;