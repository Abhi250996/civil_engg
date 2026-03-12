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
   AI DRAWING IMAGE GENERATION
============================== */

app.post("/generate-drawing", async (req, res) => {
  try {
    const prompt = req.body.prompt;

    console.log("Incoming prompt:", prompt);

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
        timeout: 60000,
      },
    );

    const imageBase64 = response.data.data[0].b64_json;

    const imageUrl = `data:image/png;base64,${imageBase64}`;

    console.log("AI IMAGE GENERATED");

    res.json({
      image: imageUrl,
    });
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

/* ==============================
   SERVER START
============================== */

app.listen(PORT, () => {
  console.log(`AI Server running on http://localhost:${PORT}`);
});
