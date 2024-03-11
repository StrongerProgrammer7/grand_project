const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');

const add_client_order = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            worker_id,
            food_id,
            food_amount,
            formation_date,
            givig_date,
            status
        } = req.body;
    if (!(worker_id && food_id && food_amount && formation_date && givig_date))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL add_client_order($1,$2,$3,$4,$5,$6)', [
        worker_id,
        food_id,
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
            // errorHandler(" Error with adding order",
            //     "23505",
            //     "Worker is exists check your data",
            //     "Internal error with registration worker!",
            //     err,
            //     next
            // )
        })


}

module.exports = add_client_order;