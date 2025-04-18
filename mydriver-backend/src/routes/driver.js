const express = require('express');
const router = express.Router();
const driverController = require('../controllers/driverController');

router.get('/orders', driverController.getOrders);
router.post('/accept-order', driverController.acceptOrder);

module.exports = router;