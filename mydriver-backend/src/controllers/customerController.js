const Booking = require('../models/booking');

exports.bookRide = async (req, res) => {
  try {
    const { customerId, source, destination, vehicleType } = req.body;
    if (!customerId || !source || !destination || !vehicleType) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    const booking = new Booking({
      customerId,
      source,
      destination,
      vehicleType,
      status: 'pending',
    });
    await booking.save();

    res.status(201).json({ message: 'Ride booked successfully', bookingId: booking._id });
  } catch (error) {
    res.status(500).json({ message: 'Error booking ride', error: error.message });
  }
};

exports.sendGoods = async (req, res) => {
  try {
    const { customerId, sender, receiver, item } = req.body;
    if (!customerId || !sender || !receiver || !item) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    // In a real app, you would save the shipment to a Shipment collection
    res.status(201).json({ message: 'Goods sent successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error sending goods', error: error.message });
  }
};