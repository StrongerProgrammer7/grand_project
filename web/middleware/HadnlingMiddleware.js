// @ts-nocheck
const ApiError = require('../Api/ApiError');
const DataApi = require('../Api/DataApi');

module.exports = function(data,req,res,next)
{
    if(data instanceof ApiError)
        return res.status(data.status).json({ message: data.message });
    
    if (data instanceof DataApi)
        return res.status(data.status).json(data);
   
    return res.status(500).json({ message: 'Undefined error!' });
}