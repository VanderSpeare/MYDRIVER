const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  phoneNumber: { type: String, required: true, unique: true }, // Revert to phoneNumber
  password: { type: String, required: true },
  role: { type: String, enum: ['customer', 'driver', 'employee'], required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('User', userSchema);