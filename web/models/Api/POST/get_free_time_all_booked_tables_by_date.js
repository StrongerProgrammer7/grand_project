const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const ApiError = require("../../../HandleAPI/ApiError");

const workingHoursStart = 8; // Начало рабочего дня
const workingHoursEnd = 23; // Конец рабочего дня

function sortFreeHours(str)
{
    let arr = str.split(',');

    arr.sort((a, b) =>
    {
        // Разделяем подстроки по "-"
        let aParts = a.split('-');
        let bParts = b.split('-');

        // Сравниваем первые цифры каждой подстроки
        return parseInt(aParts[0]) - parseInt(bParts[0]);
    });
    return arr.join();
}
function generateStartDay(workingHoursStart, workingHoursEnd)
{
    const freeTimeByTable = [];
    for (let i = workingHoursStart; i < workingHoursEnd; i++) 
    {
        freeTimeByTable.push({ start: `${ i }:00`, end: `${ i + 1 }:00` });
    }
    return freeTimeByTable;
}

const get_free_time_all_booked_tables_by_date = (bookings) =>
{
    const tableIds = new Set(bookings.map(booking => booking.table_id));
    let freeTimeByTable = generateStartDay(workingHoursStart, workingHoursEnd);

    let result = [];
    tableIds.forEach(id =>
    {
        let allDateCurrentBook = [];
        bookings.forEach(book =>
        {
            if (book.table_id !== id)
                return;

            allDateCurrentBook.push(
                {
                    start_date: new Date(book.start_date).getHours(),
                    end_date: new Date(book.end_date).getHours()
                });

        });

        let str = '';
        allDateCurrentBook.forEach((time) =>
        {
            const startBooked = time.start_date;
            const endBooked = time.end_date;
            let potentialFreeEnd = null;
            let potentialFreeStart = null;
            for (let k = 0; k < freeTimeByTable.length; k++) 
            {
                const timeSlot = freeTimeByTable[k];
                const free_start = Number(timeSlot.start.split(":")[0]);
                if (free_start < startBooked)
                {
                    potentialFreeStart = free_start;
                    potentialFreeEnd = startBooked;

                    for (let i = 0; i < freeTimeByTable.length; i++)
                    {
                        const slot = freeTimeByTable[i];
                        const tempst = Number(slot.start.split(":")[0]);
                        const tempend = Number(slot.end.split(":")[0]);
                        if (tempst == endBooked)
                            break;
                        if (tempst >= potentialFreeStart && tempend <= endBooked && i < freeTimeByTable.length)
                        {
                            freeTimeByTable.splice(i, 1);
                            i--;
                            k = 0;
                        }
                    };
                    break;

                }

            };
            //console.log(potentialFreeStart, potentialFreeEnd);
            str += `${ potentialFreeStart }-${ potentialFreeEnd },`;
        });
        if (freeTimeByTable.length > 0)
            str += `${ Number(freeTimeByTable[0].start.split(":")[0]) }-${ Number(freeTimeByTable[freeTimeByTable.length - 1].end.split(":")[0]) }`;

        str = sortFreeHours(str);
        result.push({ table_id: id, free_time: str });
        freeTimeByTable = generateStartDay(workingHoursStart, workingHoursEnd);;
    });
    return result;

}

const get_all_booked_tables = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            date,
        } = req.body;
    if (!date)
        return next(ApiError.badRequest("Don't enought data!"));

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
                "Error get_all_booked_tables, check you date, if get error, problem is internal!",
                err,
                next
            );
        })


}

module.exports = get_all_booked_tables;