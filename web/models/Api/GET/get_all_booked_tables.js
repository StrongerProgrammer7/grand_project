const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');


const addFieldInterval = (data) =>
{
    for (let i = 0; i < data.length; i++)
    {
        let elem = data[i];
        const start_date = new Date(elem.start_booking_date).getHours();
        const end_date = new Date(elem.end_booking_date).getHours();
        const interval = end_date - start_date;
        elem['interval'] = interval;
        data[i] = elem;
    }
    return data;
}

const get_all_booked_tables = async (req, res, next) =>
{

    db.query('SELECT * FROM view_all_booked_tables();')
        .then((data) =>
        {
            const result = data.rows;

            return next(DataApi.success(addFieldInterval(result), "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get all booked tables",
                [],
                "",
                "Internal error get all booked tables!",
                err,
                next
            );
        })


}

module.exports = get_all_booked_tables;