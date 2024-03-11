const ApiError = require("../../../HandleAPI/ApiError");
const logger = require('../../../logger/logger');

const errorHandlerPOST = (messageConsole, codeError, messageBadRequest, messageInternal, err, next) =>
{
    console.log(messageConsole);

    if (err && err.code && err.code === codeError)
    {
        logger.warn(err);
        return next(ApiError.badRequest(messageBadRequest));
    }
    else
    {
        logger.error(err);
        return next(ApiError.internal(messageInternal));
    }
}

module.exports = errorHandlerPOST;