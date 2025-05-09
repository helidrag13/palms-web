import pkg from 'express-openid-connect';
const { auth } = pkg;
import { authConfig } from './config.js';

export const authMiddleware = auth({
  issuerBaseURL: authConfig.issuerBaseURL,
  baseURL:        authConfig.baseURL,
  clientID:       authConfig.clientID,
  secret:         authConfig.secret,
  authRequired:   authConfig.authRequired,
  idpLogout:      authConfig.idpLogout,
});