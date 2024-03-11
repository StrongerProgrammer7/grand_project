const Router = require('express');
const router = new Router();
const { check } = require('express-validator');

const add_food = require('../models/Api/POST/add_food');
const add_food_composition = require('../models/Api/POST/add_food_composition');
const add_food_type = require('../models/Api/POST/add_food_type');
const add_ingredient = require('../models/Api/POST/add_ingridient');
const add_job_role = require('../models/Api/POST/add_job_role');
const add_table = require('../models/Api/POST/add_table');
const registration_worker = require('../models/Api/POST/registration_worker');
const book_table = require('../models/Api/POST/book_table');
const add_storehouse = require('../models/Api/POST/add_storehouse');
const add_client = require('../models/Api/POST/add_client');
const add_client_order = require('../models/Api/POST/add_client_order');
const change_order_status = require('../models/Api/POST/change_order_status');
const record_giving_time = require('../models/Api/POST/record_giving_time');
const cancel_booking = require('../models/Api/POST/cancel_booking');
const order_ingredient = require('../models/Api/POST/order_ingredient');

const get_current_orders = require('../models/Api/GET/get_current_orders');
const get_reorder_ingredients_list = require('../models/Api/GET/get_reorder_ingredients_list');
const get_all_booked_tables = require('../models/Api/GET/get_all_booked_tables');
const get_food_composition = require('../models/Api/POST/get_food_composition');
const get_free_tables = require('../models/Api/GET/get_free_tables');
const get_menu_sorted_by_type = require('../models/Api/GET/get_menu_sorted_by_type');
const get_order_history = require('../models/Api/GET/get_order_history');

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
router.post('/get_food_composition', get_food_composition);

//GET
router.get('/get_current_orders', get_current_orders);
router.get('/get_reorder_ingredients_list', get_reorder_ingredients_list);
router.get('/get_all_booked_tables', get_all_booked_tables);
router.get('/get_free_tables', get_free_tables);
router.get('/get_menu_sorted_by_type', get_menu_sorted_by_type);
router.get('/get_order_history', get_order_history);
module.exports = router;


