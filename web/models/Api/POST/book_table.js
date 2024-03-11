const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const book_table = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_table,
            order_time,
            phone_client,
            desired_booking_time
        } = req.body;
    if (!(id_table && order_time && phone_client && desired_booking_time))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('book_table', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = book_table;