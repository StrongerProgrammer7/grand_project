const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');
const order = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            worker_id,
            food_id,
            client_phone,
            food_amount,
            formation_date,
            givig_data,
            status
        } = req.body;
    if (!(worker_id && food_id && client_phone && food_amount && formation_date && givig_data))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_client_order', [worker_id,food_id,client_phone,food_amount,formation_date,givig_data,status]);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = order;