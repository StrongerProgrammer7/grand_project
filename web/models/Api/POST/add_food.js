const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');

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

    db.query('CALL add_food ($1,$2,$3,$4,$5)', [
        food_type,
        name,
        unit_of_measurement,
        price,
        weight
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Food added success!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add_food",
                ["23503"],
                "Type of food doesn't exists or your data not correct",
                "Internal error with adding dish! Try again later",
                err,
                next
            );
        })


}
module.exports = add_food;