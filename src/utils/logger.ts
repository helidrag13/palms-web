import winston from 'winston';

export const createLogger = () => {
  return winston.createLogger({
    level: 'info',
    transports: [
      new winston.transports.Console({
        format: winston.format.combine(
          winston.format.timestamp(),
          winston.format.printf(({ timestamp, level, message }) =>
            `${timestamp} [${level.toUpperCase()}]: ${message}`
          )
        ),
      }),
    ],
  });
};