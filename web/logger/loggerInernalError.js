const { createLogger, transports, format } = require("winston");

const myFormatLogsInternalError = format.printf((data) =>
{
    return `${ data.timestamp } :: ${ data.level }: ${ data.message }`;
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