const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');

const add_storehouse = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            name,
            address,
            phone
        } = req.body;
    if (!(name && address && phone))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_storage', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_storehouse;