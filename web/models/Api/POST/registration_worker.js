const bcrypt = require("bcrypt");
const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const db = require('../db');

const registration_worker = async (req, res, next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty!"));
    const
        {
            login,
            password,
            job_role,
            surname,
            first_name,
            salary,
            patronymic,
            email,
            phone,
            job_rate
        } = req.body;
    if (!(login && password && job_role && surname && first_name && salary && patronymic && email && phone && job_rate))
        return next(ApiError.badRequest("Don't enought data!"));

    const pass_hash = bcrypt.genSalt(10, (err, salt) =>
    {
        bcrypt.hash(password, 10, async (err, hash) =>
        {
            if (err)
                return next(ApiError.internal('Internal error with hash password'));

            db.query('CALL add_worker($1,$2,$3,$4,$5,$6,$7,$8, $9, $10,$11)', [
                login,
                hash,
                password,
                job_role,
                surname,
                first_name,
                salary,
                patronymic,
                email,
                phone,
                job_rate
            ])
                .then((data) =>
                {
                    console.log(data);
                    return next(DataApi.success({}, "Request execution"));
                })
                .catch((err) =>
                {
                    console.log("Error with registration worker", { color: "red" });
                    console.error(err);
                    return next(ApiError.badRequest("User is exists"));
                })

        })
    });

}

module.exports = registration_worker;