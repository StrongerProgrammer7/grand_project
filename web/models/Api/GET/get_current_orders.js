const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const add_client_order = async (req, res, next) =>
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
                "Internal error with registration worker!",
                err,
                next
            );
        })


}

module.exports = add_client_order;