const ApiError = require("../error/ApiError")

const test = async (req, res,next) =>
{
    if (!req.body)
        return next(ApiError.badRequest("Request body is empty! But Api work!"));
    return res.status(201).json({ message: "Api work!" });
}

module.exports = test;