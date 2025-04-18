const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');

router.post('/book', customerController.bookRide);
router.post('/shipment', customerController.sendGoods);

module.exports = router;