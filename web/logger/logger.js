const { createLogger,transports,format } = require("winston");

const logger = createLogger(
    {
        transports: [
            new transports.Console(),
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
            // new Postgres(
            //     {
            //         connectionString: `postgres://${process.env.USER}:${process.env.PASSWORD}@localhost:${process.env.PORT_DB}/${process.env.DATABASE}`,
            //         maxPool: 10,
            //         level: 'info',
            //         tableName: 'winston_logs',
            //     }
            // )
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