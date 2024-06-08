// userRoutes.ts
import express, { Request, Response } from 'express'
import bodyParser from "body-parser";
import User, { UserDocument } from "../models/user.model"
import { Schema } from "mongoose"
const jwt = require("jsonwebtoken")
const bcrypt = require("bcrypt")

// Creates token
const createToken = (id: Schema.Types.ObjectId) => {
    return jwt.sign({ id }, process.env.SECRET, { expiresIn: '3d' });
}
  
// Hashes passwords
async function hashPassword(password: string) {
    try {
        const hashedPassword = await bcrypt.hash(password, 10); 
        return hashedPassword;
    } catch (error) {
        throw new Error('Error hashing password');
    }
}

// Define router
const router = express.Router()

// User body parser
router.use(bodyParser.json())

// Login route
router.post('/login/email', async (req: Request, res: Response) => {
    const { email, password } = req.body
    try {
        // Find user with matching email
        const user = await User.findOne({ email })

        // Check if user exists
        if (!user) {
            return res.status(400).json({ message: "error: user-doesnt-exist" })
        }

        // Check if password is valid
        const isValidPassword = await bcrypt.compare(password, user.password)
        if (!isValidPassword) {
            return res.status(400).json({ message: "error: incorrect-password" })
        }

        // Generate token
        const token = createToken(user._id)

        return res.status(200).json({ _id: user._id, token: token})
    } catch (error) {
        console.log(error)
        return res.status(400).json({ message: "Unknown server error" })
    }
})

module.exports = router