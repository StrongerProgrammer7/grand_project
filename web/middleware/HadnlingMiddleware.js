// @ts-nocheck
const ApiError = require('../HandleAPI/ApiError');
const DataApi = require('../HandleAPI/DataApi');

module.exports = function (data, req, res, next)
{
    if (data instanceof ApiError)
        return res.status(data.status).json({ message: data.message });

    if (data instanceof DataApi)
        return res.status(data.status).json(data);

    return res.status(500).json({ message: 'Undefined error!' });
}