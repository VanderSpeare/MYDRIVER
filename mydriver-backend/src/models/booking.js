const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  customerId: { type: String, required: true },
  driverId: { type: String },
  source: { type: String, required: true },
  destination: { type: String, required: true },
  vehicleType: { type: String, required: true },
  status: { type: String, enum: ['pending', 'accepted', 'completed', 'cancelled'], default: 'pending' },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Booking', bookingSchema);