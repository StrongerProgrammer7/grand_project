const Router = require('express');
const router = new Router();
const fs = require('fs');
const logger = require('../logger/logger');
const cookierParser = require('cookie-parser');
const session = require('express-session');
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');

router.use(cookierParser());
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: true });

router.use(session(
    {
        secret: 'secretKEY',
        saveUninitialized: false,
        resave: false
    }
));

router.get('/', (req, res, next) =>
{
    //logger.info('THIS MESSAGE');
    res.render('pages/index', { title: 'Resturant' });
})


router.get('/registration', (req, res, next) =>
{
    /*
    res.writeHead(200,{'Content-Type':'text/html; charset=utf8'});
    let registerPage = fs.createReadStream('./public/registration.html','utf8');
    registerPage.pipe(res);
    */
});

const rateLimiter = rateLimit(
    {
        windowMs: 15 * 60 * 1000, // 24 hrs in milliseconds
        max: 30, // maximum number of request inside a window
        message: "You have exceeded the 30 requests limit , wait  15 min!", // the message when they exceed limit
        standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
        legacyHeaders: false, // Disable the `X-RateLimit-*` headers
    });
router.use(rateLimiter);
router.use(helmet());
router.use(csrfProtection);
module.exports = router;