const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_reorder_ingredients_list = async (req, res, next) =>
{

    db.query('SELECT * FROM get_reorder_ingredients_list();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get reorder ingredients list",
                [],
                "",
                "Internal error with get reorder ingredients list!",
                err,
                next
            );
        })


}

module.exports = get_reorder_ingredients_list;