const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const change_order_status = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_order,
            status

        } = req.body;
    if (!(id_order && status))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL change_order_status($1,$2)', [id_order, status])
        .then(() =>
        {
            return next(DataApi.success({}, "Order is change"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with change order status",
                ["23505"],
                "Order is not exists, check your data",
                "Internal error with change order status!",
                err,
                next
            );
        });

}

module.exports = change_order_status;