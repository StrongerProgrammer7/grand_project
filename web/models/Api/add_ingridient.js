const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');
const add_ingridient = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            name,
            measurement,
            critical_rate,
            price
        } = req.body;
    if (!(name && measurement && critical_rate && price))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_ingredient', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_ingridient;