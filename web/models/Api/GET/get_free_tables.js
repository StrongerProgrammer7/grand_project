const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_free_tables = async (req, res, next) =>
{

    db.query('SELECT * FROM view_free_tables();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get free tables",
                [],
                "",
                "Internal error get free tables!",
                err,
                next
            );
        })


}

module.exports = get_free_tables;