const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const ApiError = require("../../../HandleAPI/ApiError");
const { checkFormatDate } = require("../utils");

const get_booked_tables_on_date = async (req, res, next) =>
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
    db.query('SELECT * FROM get_booked_tables_on_date($1);', [date])
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get all booked tables by date",
                [],
                "",
                "Internal error get all booked tables by date!",
                err,
                next
            );
        })


}

module.exports = get_booked_tables_on_date;