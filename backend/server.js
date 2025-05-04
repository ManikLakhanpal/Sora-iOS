import express from "express";
import cors from "cors"
import geminiRoutes from "./routes/gemini.js";
import connectToDB from "./db/database.js";

const app = express();
const port = 5000;

connectToDB();


// * Middleware here
app.use(express.urlencoded({extended: true}));
app.use(express.json());
app.use(cors());

// * Routes here
app.use('/api', geminiRoutes);

app.get('/', (req, res) => {
    console.log("Hi");
    res.json("hi");
})

app.listen(port, () => {
    console.log(`Server is running on port http://localhost:${port}`);
})