const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const ApiError = require("../../../HandleAPI/ApiError");
const { checkFormatDate, deleteTimzoneDatafromdb } = require("../utils");

const get_time_for_booked_table_on_date = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_table,
            date,

        } = req.body;
    if (!(date && id_table))
        return next(ApiError.badRequest("Don't enought data!"));

    if (checkFormatDate(date, true) === false)
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31]!"));
    db.query('SELECT * FROM get_time_for_booked_table_on_date($1,$2);', [id_table, date])
        .then((data) =>
        {
            // console.log(data);
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get tables by date",
                [],
                "",
                "Internal error get all tables by date!",
                err,
                next
            );
        })


}

module.exports = get_time_for_booked_table_on_date;