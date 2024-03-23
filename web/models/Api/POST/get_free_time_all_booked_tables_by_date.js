const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const ApiError = require("../../../HandleAPI/ApiError");
const { checkFormatDate } = require("../utils");
const { get_free_time_all_booked_tables_by_date } = require('../utils');




const get_free_time_booked_tables = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            date,
        } = req.body;
    if (!date)

        return next(ApiError.badRequest("Don't enought data!"));
    if (checkFormatDate(date, true) === false)
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31]!"));
    db.query('Select  id as table_id, start_booking_date as start_date ,end_booking_date as end_date from get_booked_tables_on_date($1) ORDER BY start_date ASC;', [date])
        .then((data) =>
        {
            const all_tables = data.rows;

            return next(DataApi.success(get_free_time_all_booked_tables_by_date(all_tables), "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get free time booked tables",
                [],
                "",
                "Error get_free_time_booked_tables, check you date, if get error, problem is internal!",
                err,
                next
            );
        })


}

module.exports = get_free_time_booked_tables;