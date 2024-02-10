class DataApi 
{
    constructor(status, data, message) 
    {
        this.data = data;
        this.message = message;
        this.status = status;
    }

    static success(data, message)
    {
        return new DataApi(201, data, message);
    }

    static notlucky(message)
    {
        return new DataApi(409, {}, message);
    }

}

module.exports = DataApi;