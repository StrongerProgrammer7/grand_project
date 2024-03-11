const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('./errorHandler');
const db = require('../../db');

const add_ingridient = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    let update = false;
    const
        {
            name,
            measurement,
            critical_rate,
            price,
        } = req.body;
    if (req.body.update)
        update = req.body.update;
    if (!(name && measurement && critical_rate && price))
        return next(ApiError.badRequest("Don't enought data!"));

    if (update === false)
        return addIngredient({ name, measurement, critical_rate, price }, next);
    else
        console.log();/*const result = await db.proc('update_ingredient', []);*/


}

function updateIngrdient()
{
    return next(DataApi.success({}, "Ingredient update!"));
}

function addIngredient(data, next)
{
    db.query('CALL add_ingredient($1,$2,$3,$4)', [
        data.name,
        data.measurement,
        data.critical_rate,
        data.price
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Ingredient added!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with add ingredient",
                "23505",
                "ingredient is exists, check your data",
                "Internal error with add ingredient!",
                err,
                next
            );
        });
}
module.exports = add_ingridient;