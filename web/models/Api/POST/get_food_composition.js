const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');
const ApiError = require("../../../HandleAPI/ApiError");

const get_food_composition = async (req, res, next) =>
{

    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            food_id,
        } = req.body;
    if (!food_id)
        return next(ApiError.badRequest("Don't enought data!"));
    db.query('SELECT * FROM view_food_with_composition($1);', [food_id])
        .then((data) =>
        {
            return next(DataApi.success(data.rows, "Success!"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with get food composition",
                [],
                "",
                "Internal error get food composition!",
                err,
                next
            );
        })


}

module.exports = get_food_composition;