const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');

const add_storehouse = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            worker_id,
            storehouse_name,
            request_date,
            ingredient_id,
            ingredient_quantity,
            ingredient_weight,
            ingredient_expiry_date,
            supplied_date,
            supplied_weight,
            supplied_quantity
        } = req.body;
    if (!(worker_id && storehouse_name && request_date && ingredient_id && ingredient_quantity && ingredient_expiry_date && ingredient_weight && supplied_date && supplied_weight && supplied_quantity))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('order_ingredient', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_storehouse;