require("dotenv").config();

const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

/* READ API KEY FROM ENV */
const OPENAI_KEY = process.env.OPENAI_API_KEY;

/* ==============================
   AI DRAWING GENERATION
============================== */

app.post("/generate-drawing", async (req, res) => {
  try {
    const prompt = req.body.prompt;

    console.log("Incoming prompt:", prompt);

    const response = await axios({
      method: "post",
      url: "https://api.openai.com/v1/chat/completions",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${OPENAI_KEY}`,
      },
      data: {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content:
              "Generate civil engineering layout JSON using objects: line, rectangle, circle, pipe, equipment, dimension, text. Return ONLY JSON.",
          },
          {
            role: "user",
            content: prompt,
          },
        ],
      },
      timeout: 30000,
    });

    const aiText = response.data.choices[0].message.content;

    console.log("AI RAW RESPONSE:", aiText);

    try {
      const parsed = JSON.parse(aiText);
      res.json(parsed);
    } catch (err) {
      console.log("AI returned non JSON:", aiText);
      res.json({ objects: [] });
    }
  } catch (error) {
    console.log("SERVER ERROR:");

    if (error.response) {
      console.log(error.response.data);
      res.status(500).json(error.response.data);
    } else {
      console.log(error.message);
      res.status(500).json({ error: error.message });
    }
  }
});

app.listen(PORT, () => {
  console.log(`AI Server running on http://localhost:${PORT}`);
});
