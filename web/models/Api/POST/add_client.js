const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
const db = require('../../db');

const add_client = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            phone,
            name_client,
            last_contact_date,
            email
        } = req.body;
    if (!(phone && name_client && last_contact_date && email))
        return next(ApiError.badRequest("Don't enought data!"));

    const data = await db.query("SELECT * from client WHERE phone LIKE $1;", [phone]);
    if (data.rows.length > 0)
        return next(DataApi.notlucky("Client is exists!"));
    console.log(req.body);
    db.query('CALL add_client($1,$2,$3,$4)', [
        phone,
        name_client,
        last_contact_date,
        email
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