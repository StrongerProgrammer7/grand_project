const db = require('../db');

const workingHoursStart = 8; // Начало рабочего днѝ
const workingHoursEnd = 23; // Конец рабочего днѝ

function getDate(datetime)
{
    return datetime.split('T')[0];
}

async function checkbooking(id_table, start_datetime, end_datetime)
{
    //const date = getDate(start_datetime);
    const date = start_datetime.split(',')[0];
    const data = await db.query('SELECT * FROM get_time_for_booked_table_on_date($1,$2) ORDER BY start_booking_date ASC;', [id_table, date]);
    if (data.rows.length === 0)
        return true;

    const bookings = data.rows;
    const start_hour = start_datetime.split(',')[1].split(':')[0];//new Date(start_datetime).getHours();
    const end_hour = end_datetime.split(',')[1].split(':')[0];//new Date(end_datetime).getHours();
    console.log(start_hour, end_hour);
    for (let i = 0; i < bookings.length; i++)
    {
        const book = bookings[i];
        if (book.id === id_table)
        {
            const start = new Date(book.start_booking_date).getHours();
            const end = new Date(book.end_booking_date).getHours();
            console.log(book.start_booking_date, book.end_booking_date);
            console.log(start, end);
            if ((start_hour > start && start_hour < end) || (end_hour > start && end_hour < end) || (start == start_hour && end_hour == end))
                return false;

            if ((start_hour <= start && end_hour > end) || (start_hour < start && end_hour >= end))
                return false;

        }

    };
    return true;
}
async function isExistsClient(db, phone_client, requireClient = true)
{
    const data = await db.query("SELECT * from client WHERE phone LIKE $1;", [phone_client]);
    if (requireClient && data.rows.length === 0)
    {
        return false;
    }
    else if (requireClient === false && data.rows.length > 0)
    {
        return false;
    }
    return true;
}
async function isExistsWorker(db, id_worker)
{
    const data = await db.query("SELECT id from worker WHERE id = $1;", [id_worker]);
    if (data.rows.length === 0)
        return false;

    return true;
}

function checkFormatDate(datetimestamp, simpleCheck = false)
{
    let reg = /^(2\d{3})-(0[1-9]|1[0-2])-([0|1|2][0-9]|3[0|1]), (0[0-9]|1[0-9]|2[0-3]):([0-6][0-9]):\d{2}$/gm  ///^(2\d{3})-(0[1-9]|1[0-2])-([0|1|2][0-9]|3[0|1])T(0[0-9]|1[0-9]|2[0-4]):([0-6][0-9]):\d{2}.\d+Z$/gm;
    if (simpleCheck === true)
        reg = /^(2\d{3})-(0[1-9]|1[0-2])-([0|1|2][0-9]|3[0|1])$/gm;

    if (reg.test(datetimestamp))
        return true;
    else
        return false;
}

function sortFreeHours(str)
{
    let arr = str.split(',');

    arr.sort((a, b) =>
    {
        let aParts = a.split('-');
        let bParts = b.split('-');

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
    console.log(bookings);
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
        console.log(allDateCurrentBook);
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
                if (free_start <= startBooked)
                {
                    if (free_start === startBooked)
                    {
                        for (let i = 0; i < freeTimeByTable.length; i++)
                        {
                            const slot = freeTimeByTable[i];
                            const tempend = Number(slot.end.split(":")[0]);
                            if (tempend <= endBooked && i < freeTimeByTable.length)
                            {
                                freeTimeByTable.splice(i, 1);
                                i--;
                            } else
                                break;
                        };

                    } else
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
                            }
                        };
                    }
                    break;

                }

            };
            //console.log(potentialFreeStart, potentialFreeEnd);
            if (potentialFreeStart && potentialFreeEnd)
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

const deleteTimzoneDatafromdb = (data) =>
{
    for (let i = 0; i < data.length; i++)
    {
        const elem = data[i];
        console.log(elem);
        elem.start_booking_date = new Date(elem.start_booking_date).toLocaleString();
        elem.end_booking_date = new Date(elem.end_booking_date).toLocaleDateString();
        console.log(elem.start_booking_date);
        data[i] = elem;
    }
    return data;
}


module.exports = { isExistsClient, checkbooking, isExistsWorker, checkFormatDate, get_free_time_all_booked_tables_by_date, deleteTimzoneDatafromdb, workDay: { workingHoursEnd, workingHoursStart } }