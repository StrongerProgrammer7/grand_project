const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const book_table = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_table,
            id_worker,
            phone_client,
            order_time,
            desired_booking_time,
            booking_interval // на сколько часов заняли стол
        } = req.body;
    if (!(id_table && id_worker && order_time && phone_client && desired_booking_time))
        return next(ApiError.badRequest("Don't enought data!"));
    db.query('CALL book_table($1,$2,$3,$4,$5,$6)', [
        id_table,
        id_worker,
        phone_client,
        order_time,
        desired_booking_time,
        booking_interval
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Table is book successfully!"));
        })
        .catch(err =>
        {

            errorHandler(
                "Error with book table",
                ["23505"],
                "Table is already book or don't exists table/worker, check your data",
                "Internal error with booking table!",
                err,
                next
            );
        });


}

function calcDiffData(order_time, desired_booking_time)
{
    var date1 = new Date(order_time);
    var date2 = new Date(desired_booking_time);
    var timeDiff = Math.abs(date2.getTime() - date1.getTime());
    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
    return diffDays;
}

module.exports = book_table;