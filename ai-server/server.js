require("dotenv").config();

const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const OPENAI_KEY = process.env.OPENAI_API_KEY;

/* ==============================
   HEALTH CHECK
============================== */
app.get("/", (req, res) => {
  res.send("AI Server Running 🚀");
});

app.get("/test", (req, res) => {
  res.json({ status: "OK", message: "API working fast ✅" });
});

/* ==============================
   AI DRAWING IMAGE GENERATION (OPTIMIZED)
============================== */
app.post("/generate-drawing", async (req, res) => {
  try {
    const prompt = req.body.prompt;

    if (!prompt) {
      return res.status(400).json({ error: "Prompt is required" });
    }

    if (!OPENAI_KEY) {
      return res.status(500).json({
        error: "Missing OPENAI_API_KEY",
      });
    }

    console.log("Generating drawing:", prompt);

    const response = await axios.post(
      "https://api.openai.com/v1/images/generations",
      {
        model: "gpt-image-1",

        // 🔥 SHORT + FAST PROMPT
        prompt: `civil engineering blueprint drawing: ${prompt}`,

        size: "512x512", // 🔥 reduced size (VERY IMPORTANT)
      },
      {
        headers: {
          Authorization: `Bearer ${OPENAI_KEY}`,
        },
        timeout: 20000, // 🔥 avoid railway timeout
      }
    );

    const imageUrl = response.data?.data?.[0]?.url;

    if (!imageUrl) {
      throw new Error("No image returned");
    }

    console.log("Image generated ✅");

    return res.json({ image: imageUrl });

  } catch (error) {
    console.log("DRAW ERROR:", error.message);

    return res.status(500).json({
      error: error.response?.data || error.message,
    });
  }
});

/* ==============================
   AI CIVIL CHATBOT
============================== */
app.post("/ai-chat", async (req, res) => {
  try {
    const userMessage = req.body.message;

    if (!userMessage) {
      return res.status(400).json({ error: "Message is required" });
    }

    if (!OPENAI_KEY) {
      return res.status(500).json({
        error: "Missing OPENAI_API_KEY",
      });
    }

    console.log("AI Chat:", userMessage);

    const response = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: "gpt-4o-mini",

        messages: [
          {
            role: "system",
            content:
              "You are a professional civil engineering assistant. Give clear practical answers.",
          },
          {
            role: "user",
            content: userMessage,
          },
        ],

        temperature: 0.3,
      },
      {
        headers: {
          Authorization: `Bearer ${OPENAI_KEY}`,
        },
        timeout: 15000,
      }
    );

    const reply = response.data?.choices?.[0]?.message?.content;

    if (!reply) {
      throw new Error("No reply from AI");
    }

    return res.json({ reply });

  } catch (error) {
    console.log("CHAT ERROR:", error.message);

    return res.status(500).json({
      error: error.response?.data || error.message,
    });
  }
});

/* ==============================
   SERVER START
============================== */
app.listen(PORT, () => {
  console.log(`🚀 AI Server running on port ${PORT}`);
});