const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const add_table = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            human_slots,
        } = req.body;
    if (!human_slots)
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_table', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_table;