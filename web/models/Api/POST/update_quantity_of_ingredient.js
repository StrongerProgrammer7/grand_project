const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const update_quantity_of_ingredient = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            ingredient_id,
            quantitie,

        } = req.body;
    if (!(quantitie && ingredient_id))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL update_order($1,$2)', [
        ingredient_id,
        quantitie
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Updated order!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with update quantity_of_ingredient",
                [],
                "Order is not exists, check your data",
                "Internal error with update quantity_of_ingredient!",
                err,
                next
            );
        });
}

module.exports = update_quantity_of_ingredient;