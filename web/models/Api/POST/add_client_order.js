const ApiError = require("../../../Api/ApiError");
const DataApi = require("../../../Api/DataApi");
const db = require('../../db');

const add_client_order = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            worker_id,
            food_id,
            food_amount,
            formation_date,
            giving_date,
            status,

        } = req.body;
    if (!(worker_id && food_id && food_amount && formation_date && giving_date && status))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_client_order', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_client_order;