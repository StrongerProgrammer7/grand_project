const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');

const add_client = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            phone,
            contact, //Имя контактного лица
            last_contact_date
        } = req.body;
    if (!(phone && contact && last_contact_date))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_client', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_client;