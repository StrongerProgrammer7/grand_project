const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../../db');
const errorHandler = require("../errorHandler");

const update_worker_salary_and_rate = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            worker_id,
            new_salary,
            new_job_rate
        } = req.body;
    if (!(worker_id && new_salary && new_job_rate))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL update_worker_salary_and_rate($1,$2,$3)', [
        worker_id,
        new_salary,
        new_job_rate
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Updated salary and rate worker!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with update salary worker",
                [],
                "Worker is not exists, check your data",
                "Internal error with update salary worker!",
                err,
                next
            );
        });
}

module.exports = update_worker_salary_and_rate;