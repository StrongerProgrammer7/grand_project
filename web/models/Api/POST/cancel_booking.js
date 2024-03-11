const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');

const cancel_booking = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_table

        } = req.body;
    if (!id_table)
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('cancel_booking', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = cancel_booking;