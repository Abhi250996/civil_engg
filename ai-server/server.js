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
   HEALTH CHECK (IMPORTANT 🔥)
============================== */
app.get("/", (req, res) => {
  res.send("AI Server Running 🚀");
});

app.get("/test", (req, res) => {
  res.json({ status: "OK", message: "API working fast ✅" });
});

/* ==============================
   AI DRAWING IMAGE GENERATION
============================== */
app.post("/generate-drawing", async (req, res) => {
  try {
    const prompt = req.body.prompt;

    if (!prompt) {
      return res.status(400).json({ error: "Prompt is required" });
    }

    if (!OPENAI_KEY) {
      return res.status(500).json({
        error: "Missing OPENAI_API_KEY in environment",
      });
    }

    console.log("Generating drawing for:", prompt);

    const response = await axios.post(
      "https://api.openai.com/v1/images/generations",
      {
        model: "gpt-image-1",

        prompt: `
Create a clean civil engineering drawing diagram.

${prompt}

Style:
black technical drawing
engineering blueprint
white background
clean vector diagram
top view layout
`,

        size: "1024x1024",
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${OPENAI_KEY}`,
        },
        timeout: 30000, // 🔥 reduced timeout (important)
      }
    );

    // safer access
    const imageUrl = response.data?.data?.[0]?.url;

    if (!imageUrl) {
      return res.status(500).json({
        error: "Image generation failed",
      });
    }

    console.log("Image generated successfully ✅");

    res.json({ image: imageUrl });

  } catch (error) {
    console.log("DRAWING ERROR:");

    if (error.response) {
      console.log(error.response.data);
      return res.status(500).json(error.response.data);
    }

    console.log(error.message);
    res.status(500).json({
      error: error.message,
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
            content: `
You are a professional civil engineering assistant.

Help with:
- Concrete calculations
- Structural engineering
- Construction methods
- Steel reinforcement
- Site problems
- Engineering formulas
- Civil engineering standards

Explain answers clearly like an experienced site engineer.
`,
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
          "Content-Type": "application/json",
          Authorization: `Bearer ${OPENAI_KEY}`,
        },
        timeout: 20000, // 🔥 prevent long hang
      }
    );

    const aiReply = response.data?.choices?.[0]?.message?.content;

    if (!aiReply) {
      return res.status(500).json({
        error: "No response from AI",
      });
    }

    res.json({ reply: aiReply });

  } catch (error) {
    console.log("CHAT ERROR:");

    if (error.response) {
      console.log(error.response.data);
      return res.status(500).json(error.response.data);
    }

    console.log(error.message);
    res.status(500).json({
      error: error.message,
    });
  }
});

/* ==============================
   SERVER START
============================== */
app.listen(PORT, () => {
  console.log(`AI Server running on port ${PORT}`);
});