import express from 'express';
import { config } from './config/index.js';
import pkg from 'express-openid-connect';
import routes from './routes/index.js';
import { createLogger } from './utils/logger.js';

const { auth } = pkg;
const { requiresAuth } = pkg;
const authMiddleware = auth({
  issuerBaseURL: config.auth0.issuerBaseURL,
  baseURL:        config.baseURL,
  clientID:       config.auth0.clientId,
  secret:         config.auth0.sessionSecret,
  authRequired:   false,
  idpLogout:      true,
});

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