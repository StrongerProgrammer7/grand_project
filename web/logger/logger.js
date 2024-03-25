// @ts-nocheck
const { createLogger, transports, format } = require("winston");
const { PostgresTransport } = require('@innova2/winston-pg');

const connect_db = `postgres://${ process.env.USER ? process.env.USER : 'postgres' }:${ process.env.PASSWORD ? process.env.PASSWORD : 'root' }@${ process.env.HOST ? process.env.HOST : 'db' }:${ process.env.PORT_DB ? process.env.PORT_DB : '5432' }/${ process.env.DATABASE ? process.env.DATABASE : 'Restaurant' }`;

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
                    connectionString: connect_db,
                    maxPool: 50,
                    level: 'info',
                    tableName: 'winston_logs',
                }
            )
        ],
        format: format.combine(
            format.json(),
            format.timestamp(),
            format.prettyPrint(),
            format.metadata()
        ),
        statusLevels: true
    }
);

module.exports = logger;