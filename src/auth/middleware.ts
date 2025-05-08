import { auth } from 'express-openid-connect';
import { authConfig } from './config';

export const authMiddleware = auth({
  issuerBaseURL: authConfig.issuerBaseURL,
  baseURL:        authConfig.baseURL,
  clientID:       authConfig.clientID,
  secret:         authConfig.secret,
  authRequired:   authConfig.authRequired,
  idpLogout:      authConfig.idpLogout,
});