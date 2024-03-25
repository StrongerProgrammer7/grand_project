const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_worker_list = async (req, res, next) =>
{

    db.query('SELECT * FROM get_worker_list();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get worker_list",
                [],
                "",
                "Internal error get worker_list!",
                err,
                next
            );
        })


}

module.exports = get_worker_list;