const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');

const db = require('../../db');
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

    db.query('CALL add_job_role($1,$2,$3)', [
        name,
        min_salary,
        max_salary
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Role of worker added successfully"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add job role",
                ["23505"],
                "Role of worker is exists, check your data",
                "Internal error with add role of worker!",
                err,
                next
            );
        });


}

module.exports = add_job_role;