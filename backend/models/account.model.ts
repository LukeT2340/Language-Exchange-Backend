//user.model.ts
import mongoose, { Document, Schema } from 'mongoose'

// User document interface
export interface AccountDocument extends Document {
    _id:  Schema.Types.ObjectId,
    email?: string,
    facebookId?: string,
    googleId?: string,
    wechatId?: string,
    appleId?: string,
    password: string,
    createdAt: Date,
    updatedAt: Date
}

// Define user schema
const accountSchema = new Schema<AccountDocument>({
    email: { type: String, unique: true }, // If user signed up with email
    facebookId: { type: String, unique: true }, // If user signed up with facebook
    googleId: { type: String, unique: true }, // If user signed up with gmail
    wechatId: { type: String, unique: true }, // If user signed up with wechat
    appleId: { type: String, unique: true }, // If user signed up with apple
    password: { type: String, require: true},
    createdAt: { type: Date, require: true, default: new Date()},
    updatedAt: { type: Date, require: true}
})

// Middleware to automatically set updatedAt when user document changed
accountSchema.pre('save', function(next) {
    this.updatedAt = new Date()
    next()
})

// Export model
export default mongoose.model<AccountDocument>('Account', accountSchema)