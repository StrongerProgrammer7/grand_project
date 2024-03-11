const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');

const change_order_status = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            id_order,
            status

        } = req.body;
    if (!(id_order && status))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('change_order_status', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = change_order_status;