const { createLogger, transports, format } = require("winston");
const { PostgresTransport } = require('@innova2/winston-pg');

const logger = createLogger(
    {
        transports: [
            new transports.Console(),
            new transports.File(
                {
                    level: 'info',
                    filename: './logger/logInfo.log'
                }
            ),
            new transports.File(
                {
                    level: 'warn',
                    filename: './logger/logsWarnings.log'
                }
            ),
            new transports.File(
                {
                    level: 'error',
                    filename: './logger/logsErrors.log'
                }
            ),
            new PostgresTransport(
                {
                    connectionString: `postgres://${ process.env.USER }:${ process.env.PASSWORD }@${ process.env.HOST }:${ process.env.PORT_DB }/${ process.env.DATABASE }`,
                    maxPool: 50,
                    level: 'info',
                    tableName: 'winston_logs',
                }
            )
        ],
        format: format.combine(
            format.json(),
            format.timestamp(),
            format.prettyPrint()
        ),
        statusLevels: true
    }
);

module.exports = logger;