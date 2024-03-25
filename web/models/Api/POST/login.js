// @ts-nocheck
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const ApiError = require("../../../HandleAPI/ApiError");
const DataApi = require("../../../HandleAPI/DataApi");
const logger = require('../../../logger/logger');
const badRequestHandler = require('../badRequestHandler');
const errorHandler = require('../errorHandler');
const { validationResult } = require('express-validator');
const db = require('../../db');
const dotenv = require('dotenv').config();

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

    db.query(`Select id,password FROM worker WHERE login = $1`, [login])
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
                const token = jwt.sign({ id: human[0].id, login }, '5465454f6ad5s4f354as354f9))()(F)_Asf0a9sf09af0afi39%',
                    {
                        expiresIn: '60000s'//process.env.JWT_EXPIRES
                    });
                const cookieOption =
                {
                    expiresIn: new Date(Date.now() + 36000),
                    httpOnly: true,
                    secure: true
                }
                res.cookie("userLoggedIn", token, cookieOption);
                return next(DataApi.success({ token }, "User has been logged in!"));
                // return res.status(201).json({ status: true, success: "User has been logged in" });
            }
        })
        .catch((err) => 
        {
            console.log(err);
            errorHandler(" Error with sign in",
                [""],
                "",
                "Internal error with sign in!",
                err,
                next
            );
        });
}

module.exports = signIn;