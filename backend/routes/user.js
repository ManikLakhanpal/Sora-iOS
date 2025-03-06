import { Router } from "express";
import User from "../models/user.js";
import auth from "../middleware/auth.js";

const userRoutes = Router();

/*  
* This route takes [name, username, email, password]
* for signingup the users
*/
userRoutes.post('/signup', async (req, res) => {
    const user = new User(req.body);

    try {
        await user.save();
        res.status(201).send(user);
    } catch(error) {
        console.log(error);
        res.status(400).send(error);
    }
})

// * Login route which return JWT Token
userRoutes.post('/login', async (req, res) => {
    try {
        const user = await User.findByCredentials(req.body.email, req.body.password);
        const token = await user.generateAuthToken();

        res.status(200).send({ user, token });

    } catch (error) {
        console.log(error);
        res.status(400).send(error);
    }
})

// * LogOut Route
userRoutes.patch('/logout', auth, async (req, res) => {
    try {
        const user = await User.findOneAndUpdate(
            { email: req.user.email },
            { $pull: { tokens: { token: req.token } } }, 
            { new: true }
        );

        if (!user) {
            return res.status(404).send({ message: "User not found" });
        }

        res.status(200).send({ message: "Logged out successfully" });

    } catch (error) {
        console.log(error);
        res.status(500).send(error);
    }
});

// * Get user via id
userRoutes.get('/:id', async (req, res) => {
    try {
        const user = await User.findOne({ _id: req.params.id })
        console.log(user);
        res.status(200).send(user);
    } catch (error) {
        console.log(error);
        res.status(400).send(error);
    }
})

export default userRoutes;
