//user.model.ts
import mongoose, { Document, Schema } from 'mongoose'

// User document interface
interface UserDocument extends Document {
    email: string,
    facebookId: string,
    googleId: string,
    wechatId: string,
    appleId: string,
    profilePictureUrl: string,
    username: string,
    password: string,
    createdAt: Date,
    updatedAt: Date
}

// Define user schema
const userSchema = new Schema<UserDocument>({
    email: { type: String }, // If user signed up with email
    facebookId: { type: String }, // If user signed up with facebook
    googleId: { type: String }, // If user signed up with gmail
    wechatId: { type: String }, // If user signed up with wechat
    appleId: { type: String }, // If user signed up with apple
    profilePictureUrl: { type: String, require: true },
    username: { type: String, require: true},
    password: { type: String, require: true},
    createdAt: { type: Date, default: new Date()},
    updatedAt: { type: Date, require: true}
})

// Middleware to automatically set updatedAt when user document changed
userSchema.pre('save', function(next) {
    this.updatedAt = new Date()
    next()
})

// Export model
export default mongoose.model<UserDocument>('User', userSchema)