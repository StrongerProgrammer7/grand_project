const { createLogger,transports,format } = require("winston");

const myFormatLogsInternalError = format.printf(({ level, meta, timestamp }) =>
{
    return `${ timestamp } :: ${ level }: ${ meta.message }`;
});

const loggerInernalError = createLogger(
    {
        transports: [
            new transports.File(
                {
                    filename: './logger/logsInternalErrors.log'
                }
            )
        ],
        format: format.combine(
            format.json(),
            format.timestamp(),
            myFormatLogsInternalError
        ),
    }
);

module.exports = loggerInernalError;