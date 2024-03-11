const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');

const record_giving_time = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_order,
            giving_time

        } = req.body;
    if (!(id_order && giving_time))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('record_giving_time', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = record_giving_time;