const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');

const db = require('../../db');
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

    db.query('CALL add_food_composition($1,$2,$3)', [
        food_name,
        ingredient_name,
        ingredient_weight,
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Food composition added successfully!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add_food_composition",
                ["23502", "23505"],
                "Food name or ingredient name doesn't exists or food composition already exists",
                "Internal error with add food composition! Try again later",
                err,
                next
            );
        });


}

module.exports = add_food_composition;