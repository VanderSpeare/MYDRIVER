const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.register);
router.post('/send-otp-login', authController.sendOtpForLogin);
router.post('/verify-otp-login', authController.verifyOtpAndLogin);
router.post('/login', authController.login); // Optional, for testing without OTP

module.exports = router;