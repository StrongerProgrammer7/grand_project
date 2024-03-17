const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const update_order = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            order_id,
            food_id,
            quantities,
            new_status

        } = req.body;
    if (!(order_id && food_id && quantities && new_status))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL update_order($1,$2,$3,$4)', [
        order_id,
        food_id,
        quantities,
        new_status
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Updated order!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with update order",
                [],
                "Order is not exists, check your data",
                "Internal error with update order!",
                err,
                next
            );
        });
}

module.exports = update_order;