import mongoose from 'mongoose';

async function connectToDB() {
    try {
        mongoose.connect(`${process.env.MONGODB_URI}/sora`)
    } catch (error) {
        console.log(error);
    }
}

export default connectToDB;


