const Booking = require('../models/booking');

exports.getOrders = async (req, res) => {
  try {
    const { driverId } = req.query;
    if (!driverId) {
      return res.status(400).json({ message: 'Driver ID is required' });
    }

    const orders = await Booking.find({ driverId, status: { $in: ['pending', 'accepted'] } });
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching orders', error: error.message });
  }
};

exports.acceptOrder = async (req, res) => {
  try {
    const { orderId } = req.body;
    if (!orderId) {
      return res.status(400).json({ message: 'Order ID is required' });
    }

    const booking = await Booking.findById(orderId);
    if (!booking) {
      return res.status(404).json({ message: 'Order not found' });
    }

    booking.status = 'accepted';
    await booking.save();

    res.status(200).json({ message: 'Order accepted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error accepting order', error: error.message });
  }
};