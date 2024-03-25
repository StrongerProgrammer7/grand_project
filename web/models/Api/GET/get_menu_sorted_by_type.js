const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const get_menu_sorted_by_type = async (req, res, next) =>
{

    db.query('SELECT * FROM view_menu_sorted_by_type();')
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get menu sorted by type",
                [],
                "",
                "Internal error get menu sorted by type!",
                err,
                next
            );
        })


}

module.exports = get_menu_sorted_by_type;