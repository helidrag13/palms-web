import { Router } from 'express';
import { requiresAuth } from 'express-openid-connect';

const router = Router();

router.get('/profile', requiresAuth(), (req, res) => {
  res.json({ user: req.oidc.user });
});

export default router;