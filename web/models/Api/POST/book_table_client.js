// @ts-nocheck
const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const { checkbooking, isExistsClient, checkFormatDate, workDay } = require('../utils');


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
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!"));
    const start_day = workDay.workingHoursStart;
    const end_day = workDay.workingHoursEnd;
    const start_book_hour = start_booking_date.split(',')[1].split(':')[0];
    const end_book_hour = end_booking_date.split(',')[1].split(':')[0];
    if ((start_book_hour < start_day || start_book_hour >= end_day) || (end_book_hour > end_day || end_book_hour <= start_day))
        return next(DataApi.notlucky("Check work restaurant and change booked!"));

    if (await isExistsClient(db, phone_client) === false)
        return next(DataApi.notlucky("Client is not exists!"));

    const checkbook = await checkbooking(id_table, start_booking_date, end_booking_date);
    if (checkbook === false)
        return next(DataApi.notlucky("Current table booked, change datetime"));
    console.log(start_booking_date, end_booking_date);
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


module.exports = book_table_client;