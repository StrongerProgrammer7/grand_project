const ApiError = require("../../Api/ApiError");
const DataApi = require("../../Api/DataApi");
const db = require('../db');
const add_job_role = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            name,
            min_salary,
            max_salary
        } = req.body;
    if (!(name && min_salary && max_salary))
        return next(ApiError.badRequest("Don't enought data!"));

    /*const result = await db.proc('add_job_role', []);*/

    return next(DataApi.success({}, "Request execution"));
}

module.exports = add_job_role;