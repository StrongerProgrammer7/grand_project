const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const delete_ingredient = async (req, res, next) =>
{
    if (!req.params)
        return next(ApiError.badRequest("Request params is empty!"));
    const
        {
            id,
        } = req.params;
    if (!id)
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL delete_ingredient($1)', [id])
        .then(() =>
        {
            return next(DataApi.success({}, "Ingredient deleted"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with delete ingredient",
                ["23505"],
                "Ingredient is not exists, check your data",
                "Internal error with delete_ingredient!",
                err,
                next
            );
        });

}

module.exports = delete_ingredient;