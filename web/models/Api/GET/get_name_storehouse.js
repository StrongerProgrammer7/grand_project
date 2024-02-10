const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_name_storehouse = async (req, res, next) =>
{

    db.query('SELECT name FROM public.storehouse ORDER BY name ASC;')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get storehouse",
                [],
                "",
                "Internal error get storehouse!",
                err,
                next
            );
        })


}

module.exports = get_name_storehouse;