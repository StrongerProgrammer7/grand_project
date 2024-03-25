const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const errorHandler = require('../errorHandler');
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
            id,
        } = req.body;
    if (req.body.update)
        update = req.body.update;
    if (!(critical_rate && price))
        return next(ApiError.badRequest("Don't enought data!"));

    if (update === false)
    {
        if (!(name && measurement))
            return next(ApiError.badRequest("Don't enought data!"));
        return addIngredient({ name, measurement, critical_rate, price }, next);
    }
    else
    {
        if (!id)
            return next(ApiError.badRequest("Don't enought data!"));
        return updateIngrdient({ id, price, critical_rate }, next);
    }


}

function updateIngrdient(data, next)
{
    db.query('CALL update_ingredient($1,$2,$3)', [
        data.id,
        data.price,
        data.critical_rate
    ])
        .then(() =>
        {
            return next(DataApi.success({}, "Ingredient updated!"));
        })
        .catch(err =>
        {
            errorHandler(
                "Error with update ingredient",
                ["23505"],
                "ingredient is not exists, check your data",
                "Internal error with update ingredient!",
                err,
                next
            );
        });
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
                ["23505"],
                "ingredient is exists, check your data",
                "Internal error with add ingredient!",
                err,
                next
            );
        });
}
module.exports = add_ingridient;