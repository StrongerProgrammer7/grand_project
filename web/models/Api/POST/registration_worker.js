const bcrypt = require("bcrypt");
const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const logger = require('../../../logger/logger');
const errorHandler = require('../errorHandler');

const db = require('../../db');

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
        if (err)
        {
            logger.error(`Gen SALT: ${ err }`);
            return next(ApiError.internal('Internal error with gen salt'));
        }

        bcrypt.hash(password, 10, async (err, hash) =>
        {
            if (err)
            {
                logger.error(`Get HASH: ${ err }`);
                return next(ApiError.internal('Internal error with hash password'));
            }

            db.query('CALL add_worker($1,$2,$3,$4,$5,$6,$7,$8, $9, $10,$11)', [
                login,
                hash,
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
                    return next(DataApi.success({}, "Worker registered!"));
                })
                .catch((err) =>
                {
                    errorHandler(" Error with registration worker",
                        ["23505"],
                        "Worker is exists check your data",
                        "Internal error with registration worker!",
                        err,
                        next
                    );

                })

        })
    });

}

module.exports = registration_worker;