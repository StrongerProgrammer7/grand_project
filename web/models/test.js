const ApiError = require("../Api/ApiError");
const DataApi = require("../Api/DataApi");
const db = require('./db');
const test = async (req, res,next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty! But Api work!"));

    const newPerson = await db.query("SELECT * FROM public.client_table WHERE id_table = $1 ORDER BY id_table ASC, phone_client ASC ",[4]);
    console.log(newPerson.rows);
    return next(DataApi.success(newPerson.rows,"Request execution"));//res.status(201).json({ data: newPerson.rows});
}

module.exports = test;