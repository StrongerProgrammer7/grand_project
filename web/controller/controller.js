const Router = require('express');
const router = new Router();
const { check } = require('express-validator');
const logger = require('../logger/logger');

const test = require('../models/test');
const order = require('../models/Api/order');
const add_food = require('../models/Api/add_food');
const add_food_composition = require('../models/Api/add_food_composition');
const add_food_type = require('../models/Api/add_food_type');
const add_ingredient = require('../models/Api/add_ingridient');
const add_job_role = require('../models/Api/add_job_role');
const add_table = require('../models/Api/add_table');
const registration_worker = require('../models/Api/registration_worker');
const book_table = require('../models/Api/book_table');
const add_storehouse = require('../models/Api/add_storehouse');
const add_client = require('../models/Api/add_client');
const add_client_order = require('../models/Api/add_client_order');
const change_order_status = require('../models/Api/change_order_status');
const record_giving_time = require('../models/Api/record_giving_time');
const cancel_booking = require('../models/Api/cancel_booking');
const order_ingredient = require('../models/Api/order_ingredient');


router.post("/test", test);

router.post("/order", order);
router.post('/add_food', add_food);
router.post('/add_food_composition', add_food_composition);
router.post('/add_food_type', add_food_type);
router.post('/add_ingredient', add_ingredient);
router.post('/add_job_role', add_job_role);
router.post('/add_table', add_table);
router.post('/registration_worker', registration_worker);
router.post('/book_table', book_table);
router.post('/add_storehouse', add_storehouse);
router.post('/add_client', add_client);
router.post('/add_client_order', add_client_order);
router.post('/change_order_status', change_order_status);
router.post('/record_giving_time', record_giving_time);
router.post('/cancel_booking', cancel_booking);
router.post('/order_ingredient', order_ingredient);

module.exports = router;


