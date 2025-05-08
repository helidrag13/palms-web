import dotenv from 'dotenv';
dotenv.config();

const required = (key: string): string => {
  const val = process.env[key];
  if (!val) throw new Error(`Missing ENV var ${key}`);
  return val;
};

export const config = {
  port: Number(process.env.PORT) || 3000,
  baseURL: required('BASE_URL'),
  auth0: {
    issuerBaseURL: required('ISSUER_BASE_URL'),
    clientId: required('CLIENT_ID'),
    clientSecret: required('CLIENT_SECRET'),
    sessionSecret: required('APP_SESSION_SECRET'),
  },
};