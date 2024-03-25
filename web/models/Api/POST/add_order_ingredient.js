const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const { checkFormatDate } = require('../utils');
const add_order_ingredient = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    let update = false;
    const
        {
            worker_id,
            storage_name: storehouse,
            ingredient_id,
            ingredient_quantity,
            ingredient_weight,
            ingredient_expiry_date,
            supplied_date,
            supplied_weight,
            supplied_quantity
        } = req.body;

    if (!(worker_id && storehouse && ingredient_id && ingredient_quantity && ingredient_weight && ingredient_expiry_date && supplied_date && supplied_weight && supplied_quantity))
        return next(ApiError.badRequest("Don't enought data!"));

    if (checkFormatDate(ingredient_expiry_date) === false || checkFormatDate(supplied_date) === false)
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!"));
    db.query('CALL order_ingredient($1,$2,$3,$4,$5,$6,$7,$8,$9)', [
        worker_id,
        storehouse,
        ingredient_id,
        ingredient_quantity,
        ingredient_weight,
        ingredient_expiry_date,
        supplied_date,
        supplied_weight,
        supplied_quantity
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Order ingredient added!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add order ingredient",
                ["23505"],
                "Order ingredient is exists, check your data",
                "Internal error with add order ingredient!",
                err,
                next
            );
        });


}

module.exports = add_order_ingredient;