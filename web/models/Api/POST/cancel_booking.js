const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const cancel_booking = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_table
        } = req.body;
    if (!id_table)
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL cancel_booking($1)', [id_table])
        .then(() =>
        {
            return next(DataApi.success({}, "Booking table is cancel"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with cancel book table",
                ["23505"],
                "Table is not exists, check your data",
                "Internal error with cancel booking table!",
                err,
                next
            );
        });


}

module.exports = cancel_booking;