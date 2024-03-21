const bcrypt = require("bcrypt");
const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const logger = require('../../../logger/logger');
const badRequestHandler = require('../badRequestHandler');
const errorHandler = require('../errorHandler');
const { validationResult } = require('express-validator');
const db = require('../../db');

const signIn = async (req, res, next) =>
{
    const
        {
            login,
            password,
        } = req.body;

    const resultCheckers = validationResult(req);

    if (resultCheckers.isEmpty() == false)
        return badRequestHandler(resultCheckers, next);

    await db.query(`Select id,password FROM worker WHERE login = $1`, [login])
        .then((result) =>
        {
            console.log(result);
            if (!result)
            {
                logger.error(`Problem with get user sign in:`);
                return next(ApiError.internal('Internal error with hash password'));
            }
            return result.rows;
        })
        .then(async (human) =>
        {
            let validPassword = await bcrypt.compare(password, human[0].password);
            if (human.length === 0 || !validPassword)
            {
                return next(ApiError.badRequest('Bad request pass is not correct!'));
            } else
            {
                const token = jwt.sign({ id: human[0].id }, process.env.JWT_SECRET,
                    {
                        expiresIn: process.env.JWT_EXPIRES
                    });
                const cookieOption =
                {
                    expiresIn: new Date(Date.now() + this.process.env.COOKIE_EXPIRES),
                    httpOnly: true,
                    secure: true
                }
                res.cookie("userLoggedIn", token, cookieOption);
                return next(DataApi.success({}, "User has been logged in!"));
                // return res.status(201).json({ status: true, success: "User has been logged in" });
            }
        })
        .catch((err) => 
        {
            console.log(err);
            errorHandler(" Error with sign up",
                [""],
                "",
                "Internal error with sign up!",
                err,
                next
            );
        });
}

module.exports = signIn;