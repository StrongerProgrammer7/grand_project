const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const delete_ingredient = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_ingredient,
        } = req.body;
    if (!id_ingredient)
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL delete_ingredient($1)', [id_ingredient])
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