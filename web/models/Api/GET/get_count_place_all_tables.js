const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_count_place_all_tables = async (req, res, next) =>
{

    db.query('SELECT * FROM get_count_place_all_tables();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get_count_place_all_tables",
                [],
                "",
                "Internal error get_count_place_all_tables!",
                err,
                next
            );
        })


}

module.exports = get_count_place_all_tables;