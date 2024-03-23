// @ts-nocheck
const Router = require('express');
const router = new Router();
const { body } = require('express-validator');

const add_food = require('../models/Api/POST/add_food');
const add_food_composition = require('../models/Api/POST/add_food_composition');
const add_food_type = require('../models/Api/POST/add_food_type');
const add_ingredient = require('../models/Api/POST/add_ingridient');
const add_job_role = require('../models/Api/POST/add_job_role');
const add_table = require('../models/Api/POST/add_table');
const registration_worker = require('../models/Api/POST/registration_worker');
const book_table = require('../models/Api/POST/book_table');
const book_table_client = require('../models/Api/POST/book_table_client');
const add_storehouse = require('../models/Api/POST/add_storehouse');
const add_client = require('../models/Api/POST/add_client');
const add_client_order = require('../models/Api/POST/add_client_order');
const change_order_status = require('../models/Api/POST/change_order_status');
const record_giving_time = require('../models/Api/POST/record_giving_time');
const cancel_booking = require('../models/Api/POST/cancel_booking');

const get_food_composition = require('../models/Api/POST/get_food_composition');
const get_time_for_booked_table_on_date = require('../models/Api/POST/get_time_for_booked_table_on_date');
const get_booked_tables_on_date = require('../models/Api/POST/get_booked_tables_on_date');
const add_order_ingredient = require('../models/Api/POST/add_order_ingredient');
const update_order = require('../models/Api/POST/update_order');
const update_worker_salary_and_rate = require('../models/Api/POST/update_worker_salary_and_rate');
const update_quantity_of_ingredient = require('../models/Api/POST/update_quantity_of_ingredient');
const get_free_time_all_booked_tables_by_date = require('../models/Api/POST/get_free_time_all_booked_tables_by_date');
const signIn = require('../models/Api/POST/login');

router.post('/add_food', add_food);
router.post('/add_food_composition', add_food_composition);
router.post('/add_food_type', add_food_type);
router.post('/add_ingredient', add_ingredient);
router.post('/add_job_role', add_job_role);
router.post('/add_table', add_table);
router.post('/registration_worker',
    [
        body('login', 'Login is empty!').isEmpty(),
        body('password', 'Password length > 4 && < 255!').isLength({ min: 4, max: 255 }),
        body('email').isEmail()
    ],
    registration_worker);
router.post('/signIn',
    [
        body('login', 'Login is empty!').notEmpty(),
        body('password', 'Password is empty').notEmpty(),
    ],
    signIn);

router.post('/book_table', book_table);
router.post('/add_storehouse', add_storehouse);
router.post('/add_client', add_client);
router.post('/add_client_order', add_client_order);
router.post('/change_order_status', change_order_status);
router.post('/record_giving_time', record_giving_time);
router.post('/cancel_booking', cancel_booking);
router.post('/get_food_composition', get_food_composition);
router.post('/get_booked_tables_on_date', get_booked_tables_on_date);
router.post('/get_time_for_booked_table_on_date', get_time_for_booked_table_on_date);
router.post('/add_order_ingredient', add_order_ingredient);
router.post('/update_order', update_order);
router.post('/update_worker_salary_and_rate', update_worker_salary_and_rate);
router.post('/book_table_client', book_table_client);
router.post('/update_quantity_of_ingredient', update_quantity_of_ingredient)
router.post('/get_free_time_all_booked_tables_by_date', get_free_time_all_booked_tables_by_date);

//DELETE
const delete_ingredient = require('../models/Api/DELETE/delete_ingredient');
const delete_order = require('../models/Api/DELETE/delete_order');
const delete_worker = require('../models/Api/DELETE/delete_worker');

router.delete('/delete_ingredient/:id', delete_ingredient);
router.delete('/delete_order/:id', delete_order);
router.delete('/delete_worker/:id', delete_worker);

//GET
const get_current_orders = require('../models/Api/GET/get_current_orders');
const get_reorder_ingredients_list = require('../models/Api/GET/get_reorder_ingredients_list');
const get_all_booked_tables = require('../models/Api/GET/get_all_booked_tables');
const get_menu_sorted_by_type = require('../models/Api/GET/get_menu_sorted_by_type');
const get_ingredients_info = require('../models/Api/GET/get_ingredients_info');
const get_worker_list = require('../models/Api/GET/get_worker_list');
const get_order_history = require('../models/Api/GET/get_order_history');
const get_name_storehouse = require('../models/Api/GET/get_name_storehouse');
const get_count_place_all_tables = require('../models/Api/GET/get_count_place_all_tables');

router.get('/get_current_orders', get_current_orders);
router.get('/get_reorder_ingredients_list', get_reorder_ingredients_list);
router.get('/get_all_booked_tables', get_all_booked_tables);
router.get('/get_menu_sorted_by_type', get_menu_sorted_by_type);
router.get('/get_order_history', get_order_history);
router.get('/get_ingredients_info', get_ingredients_info);
router.get('/get_worker_list', get_worker_list);
router.get('/get_name_storehouse', get_name_storehouse);
router.get('/get_count_place_all_tables', get_count_place_all_tables);

module.exports = router;


