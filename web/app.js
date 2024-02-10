const https = require('https');
const express = require('express');
//This DB
const path = require('path');
const fs = require('fs');
const bodyParser = require('body-parser');
const fileUpload = require('express-fileupload');
const dotenv = require('dotenv').config();
//const pages = require('./routers/..');
//const controller = require('./controller/auth');

const PORT = process.env.PORT || 3000;
const urlencodedParser = express.urlencoded({ extended: true });
const app = express();

app.use(express.json());
app.use('/css', express.static(__dirname + '/public/css'));
app.use('/js', express.static(__dirname + '/public/js'));
app.use('/images', express.static(__dirname + '/public/images'));

app.engine('ejs', require('ejs-mate'));
app.set('view engine', 'ejs');
app.set('views', './views');

//app.use('/', pages);
//app.use('/api',controller)

const optionHTTPS = 
{
    key: fs.readFileSync('./certificate/key.pem'),
    cert: fs.readFileSync('./certificate/cert.pem')
}


const startServer = async function ()
{
    try
    {
        //DB
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