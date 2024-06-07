// server.ts
import express, { Request, Response } from 'express'
const cors = require('cors')
const mongoose = require('mongoose')
require("dotenv").config()

// Connection URI for your MongoDB database
const mongoURI = process.env.mongooseURI || ""

// Connect to MongoDB
mongoose.connect(mongoURI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Get the default connection
const db = mongoose.connection

// Event handlers for database connection
db.on('connected', () => {
  console.log('Connected to MongoDB')
})

db.on('error', (err: string) => {
  console.error('MongoDB connection error:', err)
})

db.on('disconnected', () => {
  console.log('Disconnected from MongoDB')
})

// Create Express app
const app = express();

// Only allow requests from the following
app.use(cors({
    origin: process.env.FRONTEND_URL,
    credentials: true
}))

const port = process.env.PORT || 3000;

// Define a route handler for the root path
app.get('/', (req: Request, res: Response) => {
    res.send('Hello World!')
});

// Start the Express server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`)
});
