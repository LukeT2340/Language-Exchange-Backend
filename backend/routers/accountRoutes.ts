// userRoutes.ts
import express, { Request, Response } from 'express'
import bodyParser from "body-parser";
import Account, { AccountDocument } from "../models/account.model"
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

// Email login route
router.post('/login/email', async (req: Request, res: Response) => {
    const { email, password } = req.body
    try {
        // Find account with matching email
        const account = await Account.findOne({ email })

        // Check if account exists
        if (!account) {
            return res.status(400).json({ message: "error: account-doesnt-exist" })
        }

        // Check if password is valid
        const isValidPassword = await bcrypt.compare(password, account.password)
        if (!isValidPassword) {
            return res.status(400).json({ message: "error: incorrect-password" })
        }

        // Generate token
        const token = createToken(account._id)

        return res.status(200).json({ _id: account._id, token: token})
    } catch (error) {
        console.log(error)
        return res.status(400).json({ message: "Unknown server error" })
    }
})

// Email sign up route
router.post('/signup/email', async (req: Request, res: Response) => {
    const { email, password } = req.body
    try {
        // Check that email doesn't already exist
        const account = await Account.findOne({ email })
        if (account) {
            return res.status(400).json({ message: "error: email-already-exists" })
        }

        // Hash the password
        const hashedPassword = await hashPassword(password)

        // Create new account
        const newAccount = new Account({
            email,
            password: hashedPassword,
        })

        // Save to database
        await newAccount.save()

        // Generate token
        const token = createToken(newAccount._id)

        // Return token to client
        return res.status(200).json({ _id: newAccount._id, token: token})
    } catch (error) {
        console.log(error)
        return res.status(400).json({ message: "Unknown server error" })
    }
})

module.exports = router