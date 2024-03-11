const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');
const db = require('../../db');

const add_client = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            phone,
            name_client,
            last_contact_date
        } = req.body;
    if (!(phone && name_client && last_contact_date))
        return next(ApiError.badRequest("Don't enought data!"));

    db.query('CALL add_client($1,$2,$3)', [
        phone,
        name_client, //Имя контактного лица
        last_contact_date
    ]).then(() =>
    {
        return next(DataApi.success({}, "Client added!"));
    })
        .catch(err =>
        {
            errorHandler(
                "Error with registration client",
                ["23505"],
                "Client is exists check your data",
                "Internal error with registration client!",
                err,
                next
            )
        })



}

module.exports = add_client;