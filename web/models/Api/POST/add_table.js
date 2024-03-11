const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');
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

    db.query('CALL add_table($1)', [human_slots])
        .then(() =>
        {
            return next(DataApi.success({}, "Table added successfully!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add table",
                "",
                "",
                "Internal error with add table!",
                err,
                next
            );
        });


}

module.exports = add_table;