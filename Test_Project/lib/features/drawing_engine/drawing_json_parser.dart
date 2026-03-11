import 'drawing_object.dart';
import 'line_object.dart';
import 'circle_object.dart';
import 'rectangle_object.dart';
import 'text_object.dart';
import 'pipe_object.dart';
import 'dimension_object.dart';
import 'equipment_object.dart';

import 'package:flutter/material.dart';

class DrawingJsonParser {
  static List<DrawingObject> parse(Map<String, dynamic> json) {
    final List<DrawingObject> objects = [];

    if (json["objects"] == null) {
      return objects;
    }

    /// scale meters → pixels
    const double scale = 8.0;

    /// shift drawing so it appears centered
    const double offsetX = 200;
    const double offsetY = 200;

    double sx(num? v) => (v ?? 0).toDouble() * scale + offsetX;
    double sy(num? v) => (v ?? 0).toDouble() * scale + offsetY;
    double ss(num? v) => (v ?? 0).toDouble() * scale;

    for (final obj in json["objects"]) {
      final type = obj["type"];

      switch (type) {
        /// =========================
        /// LINE
        /// =========================
        case "line":
          final x1 = obj["x1"] ?? obj["start"]?[0];
          final y1 = obj["y1"] ?? obj["start"]?[1];

          final x2 = obj["x2"] ?? obj["end"]?[0];
          final y2 = obj["y2"] ?? obj["end"]?[1];

          objects.add(
            LineObject(
              id: obj["id"] ?? UniqueKey().toString(),
              start: Offset(sx(x1), sy(y1)),
              end: Offset(sx(x2), sy(y2)),
            ),
          );

          break;

        /// =========================
        /// CIRCLE
        /// =========================
        case "circle":
          objects.add(
            CircleObject(
              id: obj["id"] ?? UniqueKey().toString(),
              center: Offset(sx(obj["x"]), sy(obj["y"])),
              radius: ss(obj["radius"] ?? 20),
              label: obj["label"],
            ),
          );

          break;

        /// =========================
        /// RECTANGLE
        /// =========================
        case "rectangle":
          objects.add(
            RectangleObject(
              id: obj["id"] ?? UniqueKey().toString(),
              rect: Rect.fromLTWH(
                sx(obj["x"]),
                sy(obj["y"]),
                ss(obj["width"] ?? 50),
                ss(obj["height"] ?? 50),
              ),
              label: obj["label"],
            ),
          );

          break;

        /// =========================
        /// TEXT
        /// =========================
        case "text":
          objects.add(
            TextObject(
              id: obj["id"] ?? UniqueKey().toString(),
              position: Offset(sx(obj["x"]), sy(obj["y"])),
              text: obj["text"] ?? "",
            ),
          );

          break;

        /// =========================
        /// PIPE
        /// =========================
        case "pipe":
          final x1 = obj["x1"] ?? obj["start"]?[0];
          final y1 = obj["y1"] ?? obj["start"]?[1];

          final x2 = obj["x2"] ?? obj["end"]?[0];
          final y2 = obj["y2"] ?? obj["end"]?[1];

          objects.add(
            PipeObject(
              id: obj["id"] ?? UniqueKey().toString(),
              start: Offset(sx(x1), sy(y1)),
              end: Offset(sx(x2), sy(y2)),
              pipeLabel: obj["label"],
            ),
          );

          break;

        /// =========================
        /// EQUIPMENT
        /// =========================
        case "equipment":
          EquipmentType typeEnum = EquipmentType.generic;

          final equipmentType = obj["equipmentType"];

          if (equipmentType == "tank") {
            typeEnum = EquipmentType.tank;
          } else if (equipmentType == "pump") {
            typeEnum = EquipmentType.pump;
          } else if (equipmentType == "valve") {
            typeEnum = EquipmentType.valve;
          } else if (equipmentType == "compressor") {
            typeEnum = EquipmentType.compressor;
          } else if (equipmentType == "exchanger") {
            typeEnum = EquipmentType.exchanger;
          }

          objects.add(
            EquipmentObject(
              id: obj["id"] ?? UniqueKey().toString(),
              position: Offset(sx(obj["x"]), sy(obj["y"])),
              type: typeEnum,
              label: obj["label"],
            ),
          );

          break;

        /// =========================
        /// DIMENSION
        /// =========================
        case "dimension":
          final x1 = obj["x1"] ?? obj["start"]?[0];
          final y1 = obj["y1"] ?? obj["start"]?[1];

          final x2 = obj["x2"] ?? obj["end"]?[0];
          final y2 = obj["y2"] ?? obj["end"]?[1];

          objects.add(
            DimensionObject(
              id: obj["id"] ?? UniqueKey().toString(),
              start: Offset(sx(x1), sy(y1)),
              end: Offset(sx(x2), sy(y2)),
              value: obj["value"] ?? "",
            ),
          );

          break;
      }
    }

    return objects;
  }
}
