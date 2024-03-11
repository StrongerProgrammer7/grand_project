const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const add_food = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            food_type,
            name,
            unit_of_measurement,
            price,
            weight,
        } = req.body;
    if (!(food_type && name && unit_of_measurement && price && weight))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_food', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_food;