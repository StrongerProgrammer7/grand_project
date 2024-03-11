const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const add_food_type = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            type,
        } = req.body;
    if (!type)
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_food_type', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_food_type;