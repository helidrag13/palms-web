import { config } from '../config/index.js';

export const authConfig = {
  issuerBaseURL: config.auth0.issuerBaseURL,
  baseURL: config.baseURL,
  clientID: config.auth0.clientId,
  secret: config.auth0.sessionSecret,
  authRequired: false,
  idpLogout: true,
};