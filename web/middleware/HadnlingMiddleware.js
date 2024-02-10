// @ts-nocheck
const ApiError = require('../HandleAPI/ApiError');
const DataApi = require('../HandleAPI/DataApi');
const loggerInernalError = require('../logger/loggerInernalError');
let stringify = require('json-stringify-safe');

module.exports = function (data, req, res, next)
{
    if (data instanceof ApiError)
        return res.status(data.status).json({ message: data.message });

    if (data instanceof DataApi)
        return res.status(data.status).json(data);

    loggerInernalError.error(`req=${ stringify(req) }\n\n\n data=${ data } \n `);
    return res.status(500).json({ message: 'Undefined error!' });
}