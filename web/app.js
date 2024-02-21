const https = require('https');
const express = require('express');
const expressWinston = require('express-winston');
const cors = require('cors');

const fs = require('fs');
const bodyParser = require('body-parser');
const fileUpload = require('express-fileupload');
const dotenv = require('dotenv').config();

const pages = require('./routers/router');
const controller = require('./controller/controller');
const errorHandler = require('./middleware/HadnlingMiddleware');
const logger = require('./logger/logger');
const loggerInernalError = require('./logger/loggerInernalError');

const PORT = process.env.PORT || 443;
const urlencodedParser = express.urlencoded({ extended: true });
const app = express();


app.use(expressWinston.logger(
    {
        winstonInstance: logger,
        statusLevels: true
    }
));

app.use(expressWinston.errorLogger(
    {
        winstonInstance:loggerInernalError
    }
))
// app.all('*',function(req, res, next) {
//   res.header("Access-Control-Allow-Origin", "*");
//   res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//   next();
// });


app.use(express.json());
app.use('/css', express.static(__dirname + '/public/css'));
app.use('/js', express.static(__dirname + '/public/js'));
app.use('/images', express.static(__dirname + '/public/images'));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(fileUpload());

app.engine('ejs', require('ejs-mate'));
app.set('view engine', 'ejs');
app.set('views', './views');

app.use(cors({ origin: 'http://localhost:5000'/*['http://localhost:3000','http://localhost:8080']*/, credentials: true }));
app.use(function (req, res, next)
{
    //res.header('Content-Type', 'application/json;charset=UTF-8');
    res.header('Access-Control-Allow-Credentias', true);
    res.header(
        'Access-Control-Allow-Headers',
        'Origin, X-Requested-With, Content-Type, Accept'
    );
    next();
});

app.use('/', pages);
app.use('/api', controller)

app.use(errorHandler);

const optionHTTPS =
{
    key: fs.readFileSync('./certificate/cert-key.pem'),
    cert: fs.readFileSync('./certificate/cert.pem')
}


const startServer = async function ()
{
    try
    {
        https.createServer(optionHTTPS, app)
            .listen(PORT, () =>
            {
                console.log(`Server has been started on the port ${ PORT } and HTTPS. Env=${ process.env.NODE_ENV }`);
            })
    }
    catch (error)
    {
        console.log(error);
        console.error(`Unable to connect to the server(https): PORT=${ PORT }`);
    }
}
startServer();