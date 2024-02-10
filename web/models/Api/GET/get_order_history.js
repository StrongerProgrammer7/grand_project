const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_order_history = async (req, res, next) =>
{

    db.query('SELECT * FROM view_order_history();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get order history",
                [],
                "",
                "Internal error get order history!",
                err,
                next
            );
        })


}

module.exports = get_order_history;