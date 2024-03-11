const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_all_booked_tables = async (req, res, next) =>
{

    db.query('SELECT * FROM view_all_booked_tables();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
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