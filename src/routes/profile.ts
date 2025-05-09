import { Router } from 'express';
import pkg from 'express-openid-connect';
const { requiresAuth } = pkg;

const router = Router();

router.get('/profile', requiresAuth(), (req, res) => {
  res.json({ user: req.oidc.user });
});

export default router;