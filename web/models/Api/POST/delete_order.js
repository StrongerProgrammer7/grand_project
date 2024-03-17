const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const delete_order = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_order

        } = req.body;
    if (!(id_order && status))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL delete_order($1)', [id_order])
        .then(() =>
        {
            return next(DataApi.success({}, "Order deleted"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with delete order",
                ["23505"],
                "Order is not exists, check your data",
                "Internal error with delete order !",
                err,
                next
            );
        });

}

module.exports = delete_order;