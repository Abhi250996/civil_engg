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
        temperature: 0.2,
      },
      timeout: 30000,
    });
    let aiText = response.data.choices[0].message.content;

    console.log("AI RAW RESPONSE:", aiText);

    /* remove markdown */
    aiText = aiText
      .replace(/```json/g, "")
      .replace(/```/g, "")
      .trim();

    try {
      const parsed = JSON.parse(aiText);

      const objects = [];

      const layout = parsed.layout || parsed;

      /* ================= SITE ================= */

      if (layout.site) {
        objects.push({
          type: "rectangle",
          x: 0,
          y: 0,
          width: layout.site.length || 200,
          height: layout.site.width || 200,
          label: "Site",
        });
      }

      /* ================= STRUCTURE ================= */

      if (layout.structure) {
        const pos = layout.structure.position || { x: 50, y: 50 };

        objects.push({
          type: "rectangle",
          x: pos.x,
          y: pos.y,
          width: layout.structure.length || 50,
          height: layout.structure.width || 30,
          label: "Building",
        });
      }

      /* ================= OBJECT LIST ================= */

      if (layout.objects) {
        layout.objects.forEach((o) => {
          if (o.type === "rectangle") {
            const pos = o.position || { x: 0, y: 0 };

            objects.push({
              type: "rectangle",
              x: pos.x,
              y: pos.y,
              width: o.width || o.length || 40,
              height: o.height || o.width || 40,
              label: "Structure",
            });
          }

          if (o.type === "circle") {
            const pos = o.position || { x: 0, y: 0 };

            objects.push({
              type: "circle",
              x: pos.x,
              y: pos.y,
              radius: o.radius || 5,
              label: o.label || "Equipment",
            });
          }
        });
      }

      /* ================= EQUIPMENT ================= */

      if (layout.equipment) {
        layout.equipment.forEach((eq) => {
          const pos = eq.position || { x: 0, y: 0 };

          objects.push({
            type: "circle",
            x: pos.x,
            y: pos.y,
            radius: eq.radius || 5,
            label: eq.label || eq.type || "Equipment",
          });
        });
      }

      /* ================= PIPES ================= */

      if (layout.pipes) {
        layout.pipes.forEach((pipe) => {
          const start = pipe.start || pipe.position?.start || { x: 0, y: 0 };
          const end = pipe.end || pipe.position?.end || { x: 50, y: 50 };

          objects.push({
            type: "pipe",
            x1: start.x,
            y1: start.y,
            x2: end.x,
            y2: end.y,
            label: "Pipe",
          });
        });
      }

      /* ================= LINES ================= */

      if (layout.lines) {
        layout.lines.forEach((line) => {
          objects.push({
            type: "line",
            x1: line.start.x,
            y1: line.start.y,
            x2: line.end.x,
            y2: line.end.y,
          });
        });
      }

      /* ================= DIMENSIONS ================= */

      if (layout.dimensions) {
        layout.dimensions.forEach((d) => {
          const start = d.start || { x: 0, y: 0 };
          const end = d.end || { x: 100, y: 0 };

          objects.push({
            type: "dimension",
            x1: start.x,
            y1: start.y,
            x2: end.x,
            y2: end.y,
            value: d.label || d.text || "Dimension",
          });
        });
      }

      /* ================= TEXT ================= */

      if (layout.text) {
        layout.text.forEach((t) => {
          objects.push({
            type: "text",
            x: t.position.x,
            y: t.position.y,
            text: t.content,
          });
        });
      }

      console.log("Converted Objects:", objects.length);

      res.json({ objects });
    } catch (err) {
      console.log("JSON PARSE ERROR:", err.message);

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

/* ==============================
   SERVER START
============================== */

app.listen(PORT, () => {
  console.log(`AI Server running on http://localhost:${PORT}`);
});
