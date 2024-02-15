const Router = require('express');
const router = new Router();
const { check } = require('express-validator');

const test = require('../models/test');

router.post("/test", test);


module.exports = router;