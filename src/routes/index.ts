import { Router } from 'express';
import authRoutes from './auth';
import profileRoutes from './profile';
import timeRoutes from './time';

const router = Router();

router.use(authRoutes);
router.use(profileRoutes);
router.use(timeRoutes);

export default router;