const User = require('../models/user');
const bcrypt = require('bcrypt');
const twilio = require('twilio');
require('dotenv').config();

// Twilio configuration
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioClient = twilio(accountSid, authToken);
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;

// Temporary store for OTP (use Redis or MongoDB in production)
const otpStore = new Map();

exports.register = async (req, res) => {
  try {
    const { phoneNumber, password, role } = req.body;
    if (!phoneNumber || !password || !role) {
      return res.status(400).json({ message: 'Phone number, password, and role are required' });
    }

    const existingUser = await User.findOne({ phoneNumber });
    if (existingUser) {
      return res.status(400).json({ message: 'Phone number already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({ phoneNumber, password: hashedPassword, role });
    await user.save();

    res.status(201).json({ message: 'User registered successfully', userId: user._id });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user', error: error.message });
  }
};

exports.sendOtpForLogin = async (req, res) => {
  try {
    const { phoneNumber } = req.body;
    if (!phoneNumber) {
      return res.status(400).json({ message: 'Phone number is required' });
    }

    // Generate a 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    otpStore.set(phoneNumber, { otp, expires: Date.now() + 2 * 60 * 1000 }); // OTP expires in 2 minutes

    // Send OTP via Twilio
    await twilioClient.messages.create({
      body: `Your OTP for MyDriver login is ${otp}`,
      from: twilioPhoneNumber,
      to: phoneNumber,
    });

    res.status(200).json({ message: 'OTP sent successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error sending OTP', error: error.message });
  }
};

exports.verifyOtpAndLogin = async (req, res) => {
  try {
    const { phoneNumber, password, otp } = req.body;
    if (!phoneNumber || !password || !otp) {
      return res.status(400).json({ message: 'Phone number, password, and OTP are required' });
    }

    // Verify OTP
    const otpData = otpStore.get(phoneNumber);
    if (!otpData || otpData.otp !== otp || Date.now() > otpData.expires) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    // OTP is valid, proceed with login
    const user = await User.findOne({ phoneNumber });
    if (!user) {
      return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Clear OTP after successful verification
    otpStore.delete(phoneNumber);

    res.status(200).json({ message: 'Login successful', role: user.role });
  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error: error.message });
  }
};
exports.sendOtpForRegister = async (req, res) => {
  try {
    const { phoneNumber } = req.body;
    if (!phoneNumber) {
      return res.status(400).json({ message: 'Phone number is required' });
    }

    // Generate a 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    otpStore.set(phoneNumber, { otp, expires: Date.now() + 2 * 60 * 1000 }); // OTP expires in 2 minutes

    // Send OTP via Twilio
    await twilioClient.messages.create({
      body: `Your OTP for MyDriver registration is ${otp}`,
      from: twilioPhoneNumber,
      to: phoneNumber,
    });

    res.status(200).json({ message: 'OTP sent successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error sending OTP', error: error.message });
  }
};

exports.register = async (req, res) => {
  try {
    const { phoneNumber, password, role, otp } = req.body;
    if (!phoneNumber || !password || !role || !otp) {
      return res.status(400).json({ message: 'Phone number, password, role, and OTP are required' });
    }

    // Verify OTP
    const otpData = otpStore.get(phoneNumber);
    if (!otpData || otpData.otp !== otp || Date.now() > otpData.expires) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    const existingUser = await User.findOne({ phoneNumber });
    if (existingUser) {
      return res.status(400).json({ message: 'Phone number already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({ phoneNumber, password: hashedPassword, role });
    await user.save();

    // Clear OTP after successful registration
    otpStore.delete(phoneNumber);

    res.status(201).json({ message: 'User registered successfully', userId: user._id });
  } catch (error) {
    res.status(500).json({ message: 'Error registering user', error: error.message });
  }
};
// Keep the login route for fallback or testing (optional)
exports.login = async (req, res) => {
  try {
    const { phoneNumber, password } = req.body;
    if (!phoneNumber || !password) {
      return res.status(400).json({ message: 'Phone number and password are required' });
    }

    const user = await User.findOne({ phoneNumber });
    if (!user) {
      return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    res.status(200).json({ message: 'Login successful', role: user.role });
  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error: error.message });
  }
};