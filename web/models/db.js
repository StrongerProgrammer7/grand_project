const Pool = require('pg').Pool;
const pool = new Pool(
    {
        user: process.env.USER,
        password: process.env.PASSWORD,
        host: process.env.HOST,
        port: Number(process.env.PORT_DB) || 5442,
        database: process.env.DATABASE
    }
)

module.exports = pool;