const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const { checkFormatDate } = require("../utils");

const cancel_booking = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_table,
            desired_booking_date
        } = req.body;
    if (!(id_table && desired_booking_date))
        return next(ApiError.badRequest("Don't enought data!"));

    if (checkFormatDate(desired_booking_date) === false)
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!"));

    db.query('CALL cancel_booking($1,$2)', [id_table, desired_booking_date])
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