const ApiError = require("../../../HandleAPI/ApiError");
const logger = require('../../../logger/logger');

const errorHandlerPOST = (messageConsole, codeError, messageBadRequest, messageInternal, err, next) =>
{
    console.log(messageConsole);
    if (err.code)
    {
        let isExistsCode = false;
        for (let i = 0; i < codeError.length; i++)
        {
            if (codeError[i] === err.code)
            {
                isExistsCode = true;
                break;
            }
        }
        if (isExistsCode)
        {
            logger.warn(err);
            return next(ApiError.badRequest(messageBadRequest));
        }

    }
    else
    {
        logger.error(err);
        return next(ApiError.internal(messageInternal));
    }
    return next(ApiError.internal(messageInternal));
}

module.exports = errorHandlerPOST;