const Router = require('express');
const router = new Router();
const fs = require('fs');
const logger = require('../logger/logger');
const cookierParser = require('cookie-parser');
const session = require('express-session');
router.use(cookierParser());

router.use(session(
    {
        secret: 'secretKEY',
        saveUninitialized: false,
        resave: false
    }
));

router.get('/', (req, res,next) =>
{
    logger.info('THIS MESSAGE');
    res.render('pages/index', { title: 'Resturant' });
})


router.get('/registration', (req, res,next) =>
{
    /*
    res.writeHead(200,{'Content-Type':'text/html; charset=utf8'});
    let registerPage = fs.createReadStream('./public/registration.html','utf8');
    registerPage.pipe(res);
    */
});

module.exports = router;