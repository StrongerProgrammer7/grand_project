const ApiError = require("../../HandleAPI/ApiError");
const logger = require("../../logger/logger");

const badRequestHandler = (resultCheckers, next) =>
{
    const errors = resultCheckers.array();
    logger.info(errors);
    let msg = '';
    errors.forEach((elem) =>
    {
        msg += elem.msg + ' ----- ';
    });
    return next(ApiError.badRequest(`${ msg }`));
}

module.exports = badRequestHandler;