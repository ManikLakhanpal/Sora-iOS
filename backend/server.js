import express from "express";
import cors from "cors"
import geminiRoutes from "./routes/gemini.js";
import connectToDB from "./db/database.js";

const app = express();
const port = 5000;
app.use(cors());

app.use(express.urlencoded({extended: true}));
app.use(express.json());

// * Setting up ejs for rendering
app.set('view engine', 'ejs');

app.use('/api', geminiRoutes);

connectToDB();

app.get('/', (req, res) => {
    console.log("Hi");
    res.json("hi");
})

app.listen(port, () => {
    console.log(`Server is running on port http://localhost:${port}`);
})