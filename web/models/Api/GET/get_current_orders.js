const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_current_orders = async (req, res, next) =>
{

    db.query('SELECT * FROM get_current_orders();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get current orders",
                [],
                "",
                "Internal error get current orders!",
                err,
                next
            );
        })


}

module.exports = get_current_orders;