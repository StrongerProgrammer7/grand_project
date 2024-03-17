const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const record_giving_time = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_order,
            giving_time

        } = req.body;
    if (!(id_order && giving_time))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL record_giving_time($1,$2)', [
        id_order,
        giving_time
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Updated giving time order!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with update giving_time order by id",
                [],
                "Order is not exists, check your data",
                "Internal error with update giving_time order by id!",
                err,
                next
            );
        });
}

module.exports = record_giving_time;