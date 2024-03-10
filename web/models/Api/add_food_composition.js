const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');
const add_food_composition = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            food_name,
            ingredient_name,
            ingredient_weight,
        } = req.body;
    if (!(food_name && ingredient_name && ingredient_weight))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_food_composition', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_food_composition;