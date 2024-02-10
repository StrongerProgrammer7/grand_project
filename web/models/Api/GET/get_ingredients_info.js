const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_ingredients_info = async (req, res, next) =>
{

    db.query('SELECT * FROM get_ingredients_info();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get info about ingredients",
                [],
                "",
                "Internal error get info about ingredients!",
                err,
                next
            );
        })


}

module.exports = get_ingredients_info;