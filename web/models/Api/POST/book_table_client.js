const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

function getDate(datetime)
{
    return datetime.split('T')[0];
}

async function checkbooking(id_table, start_datetime, end_datetime)
{
    const date = getDate(start_datetime);

    const data = await db.query('SELECT * FROM get_time_for_booked_table_on_date($1,$2) ORDER BY start_booking_date ASC;', [id_table, date]);
    if (data.rows.length === 0)
        return true;

    const bookings = data.rows;
    const start_hour = new Date(start_datetime).getHours();
    const end_hour = new Date(end_datetime).getHours();
    console.log(start_hour, end_hour);
    for (let i = 0; i < bookings.length; i++)
    {
        const book = bookings[i];
        if (book.id === id_table)
        {
            const start = new Date(book.start_booking_date).getHours();
            const end = new Date(book.end_booking_date).getHours();

            console.log(start, end);
            if ((start_hour > start && start_hour < end) || (end_hour > start && end_hour < end) || (start == start_hour && end_hour == end))
                return false;

            if ((start_hour <= start && end_hour > end) || (start_hour < start && end_hour >= end))
                return false;

        }

    };
    return true;
}


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

    const data = await db.query("SELECT * from client WHERE phone LIKE $1;", [phone_client]);
    if (data.rows.length === 0)
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