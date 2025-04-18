const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors()); // Allow cross-origin requests from Flutter
app.use(express.json()); // Parse JSON bodies

// MongoDB Connection
const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);

let db;

async function connectToMongo() {
  try {
    await client.connect();
    console.log('Connected to MongoDB');
    db = client.db('Mydriver'); // Database name
  } catch (error) {
    console.error('Error connecting to MongoDB:', error);
  }
}

connectToMongo();

// API Endpoint to Save User
app.post('/api/register', async (req, res) => {
  try {
    const { phoneNumber, password } = req.body;

    // Validate request body
    if (!phoneNumber || !password) {
      return res.status(400).json({ message: 'Phone number and password are required' });
    }

    const userCollection = db.collection('user'); // Collection name
    const newUser = {
      phoneNumber,
      password, // In a real app, hash the password before saving
      createdAt: new Date(),
    };

    const result = await userCollection.insertOne(newUser);
    res.status(201).json({ message: 'User registered successfully', userId: result.insertedId });
  } catch (error) {
    console.error('Error saving user:', error);
    res.status(500).json({ message: 'Error saving user' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

// Handle process termination gracefully
process.on('SIGINT', async () => {
  await client.close();
  console.log('MongoDB connection closed');
  process.exit(0);
});
const express = require('express');
const cors = require('cors');
const connectToMongo = require('./src/config/db');
const authRoutes = require('./src/routes/auth');
const customerRoutes = require('./src/routes/customer');
const driverRoutes = require('./src/routes/driver');
const employeeRoutes = require('./src/routes/employee');
require('dotenv').config();


// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectToMongo();

// Routes
app.use('/api', authRoutes);
app.use('/api/customer', customerRoutes);
app.use('/api/driver', driverRoutes);
app.use('/api/employee', employeeRoutes);

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});