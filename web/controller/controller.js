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

module.exports = router;