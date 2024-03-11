const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');
const db = require('../../db');

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

    db.query('CALL add_storage($1,$2,$3)', [
        name,
        address,
        phone
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Storehouse added successfully!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add storehouse",
                ["23505"],
                "Storehouse is exists, check your data",
                "Internal error with add storehouse!",
                err,
                next
            );
        });


}

module.exports = add_storehouse;