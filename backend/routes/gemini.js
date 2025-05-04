import { Router } from "express";
import { GoogleGenerativeAI } from "@google/generative-ai";
import verifyFirebaseToken from "../middleware/firebaseAuth.js";

const geminiRoutes = Router();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

geminiRoutes.post('/chat', verifyFirebaseToken, async (req, res) => {
    const chatHistory = req.body.history;
    const message = req.body.chat;

    const chat = model.startChat({ history: chatHistory });
    const result = await chat.sendMessage(message);
    const response = result.response;
    const text = response.text();

    res.json({"text": text});
})

geminiRoutes.post('/stream', verifyFirebaseToken, async (req, res) => {
  res.setHeader('Content-Type', 'text/plain; charset=utf-8');
  res.setHeader('Transfer-Encoding', 'chunked');
  res.setHeader('Cache-Control', 'no-cache');
  
    const chatHistory = req.body.history;
    const msg = req.body.chat;
  
    const chat = model.startChat({ history: chatHistory });

    const result = await chat.sendMessageStream(msg);

    for await (const chunk of result.stream) {
      const chunkText = chunk.text();
      res.write(chunkText);
    }
    
    res.end();
  });

export default geminiRoutes;