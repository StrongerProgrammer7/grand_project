const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');
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

    db.query('CALL add_food_type($1)', [type])
        .then(() =>
        {
            return next(DataApi.success({}, "Type of food added!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add type of food",
                "23505",
                "Type of food is exists, check your data",
                "Internal error with add type of food!",
                err,
                next
            );
        })


}

module.exports = add_food_type;