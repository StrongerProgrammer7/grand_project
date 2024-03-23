const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");
const { checkFormatDate } = require("../utils");

const add_client_order = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            worker_id,
            food_ids,
            food_amount,
            formation_date,
            givig_date,
            status
        } = req.body;
    if (!(worker_id && food_ids && food_amount && formation_date && givig_date && food_ids.length > 0))
        return next(ApiError.badRequest("Don't enought data!"));

    if (checkFormatDate(formation_date) === false || checkFormatDate(givig_date) === false)
        return next(DataApi.notlucky("Date does not match the format 2{4}-[01-12]-[01-31]T[00-24]:[00-60]:{2}.d+Z!"));

    db.query('CALL add_client_order($1,$2,$3,$4,$5,$6)', [
        worker_id,
        food_ids,
        food_amount,
        formation_date,
        givig_date,
        status])
        .then((data) =>
        {
            console.log(data);
            return next(DataApi.success({}, "Order added"));
        })
        .catch(err =>
        {
            console.log(err);
            errorHandler(" Error with adding order",
                "23503",
                "Food not exists check",
                "Internal error with add_client_order !",
                err,
                next
            )
        })


}

module.exports = add_client_order;