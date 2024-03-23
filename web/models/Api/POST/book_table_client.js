const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const { checkbooking, isExistsClient, checkFormatDate } = require('../utils');



const book_table_client = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));

    const
        {
            id_table,
            phone_client,
            order_time,
            start_booking_date,
            end_booking_date
        } = req.body;

    if (!(id_table && order_time && phone_client && start_booking_date && end_booking_date))
        return next(ApiError.badRequest("Don't enought data!"));

    if (checkFormatDate(start_booking_date) === false || checkFormatDate(end_booking_date) === false)
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31]T[00-24]:[00-60]:{2}.d+Z!"));
    if (await isExistsClient(db, phone_client) === false)
        return next(DataApi.notlucky("Client is not exists!"));

    const checkbook = await checkbooking(id_table, start_booking_date, end_booking_date);
    if (checkbook === false)
        return next(DataApi.notlucky("Current table booked, change datetime"));

    db.query('CALL book_table_from_web($1,$2,$3,$4,$5)', [
        id_table,
        phone_client,
        order_time,
        start_booking_date,
        end_booking_date
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Table is book successfully!"));
        })
        .catch(err =>
        {

            errorHandler(
                "Error with book table client",
                ["23505", "P0001"],
                "Table is already book or don't exists table/client, check your data",
                "Client or table doens't exists!",
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

module.exports = book_table_client;