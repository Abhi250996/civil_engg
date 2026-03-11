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

    for (final obj in json["objects"]) {
      final type = obj["type"];

      switch (type) {
        /// =========================
        /// LINE
        /// =========================
        case "line":
          final x1 = obj["x1"] ?? obj["start"]?[0] ?? 0;
          final y1 = obj["y1"] ?? obj["start"]?[1] ?? 0;

          final x2 = obj["x2"] ?? obj["end"]?[0] ?? 0;
          final y2 = obj["y2"] ?? obj["end"]?[1] ?? 0;

          objects.add(
            LineObject(
              id: obj["id"] ?? UniqueKey().toString(),
              start: Offset(x1.toDouble(), y1.toDouble()),
              end: Offset(x2.toDouble(), y2.toDouble()),
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
              center: Offset(
                (obj["x"] ?? 0).toDouble(),
                (obj["y"] ?? 0).toDouble(),
              ),
              radius: (obj["radius"] ?? 20).toDouble(),
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
                (obj["x"] ?? 0).toDouble(),
                (obj["y"] ?? 0).toDouble(),
                (obj["width"] ?? 50).toDouble(),
                (obj["height"] ?? 50).toDouble(),
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
              position: Offset(
                (obj["x"] ?? 0).toDouble(),
                (obj["y"] ?? 0).toDouble(),
              ),
              text: obj["text"] ?? "",
            ),
          );

          break;

        /// =========================
        /// PIPE
        /// =========================
        case "pipe":
          final x1 = obj["x1"] ?? obj["start"]?[0] ?? 0;
          final y1 = obj["y1"] ?? obj["start"]?[1] ?? 0;

          final x2 = obj["x2"] ?? obj["end"]?[0] ?? 0;
          final y2 = obj["y2"] ?? obj["end"]?[1] ?? 0;

          objects.add(
            PipeObject(
              id: obj["id"] ?? UniqueKey().toString(),
              start: Offset(x1.toDouble(), y1.toDouble()),
              end: Offset(x2.toDouble(), y2.toDouble()),
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
              position: Offset(
                (obj["x"] ?? 0).toDouble(),
                (obj["y"] ?? 0).toDouble(),
              ),
              type: typeEnum,
              label: obj["label"],
            ),
          );

          break;

        /// =========================
        /// DIMENSION
        /// =========================
        case "dimension":
          final x1 = obj["x1"] ?? obj["start"]?[0] ?? 0;
          final y1 = obj["y1"] ?? obj["start"]?[1] ?? 0;

          final x2 = obj["x2"] ?? obj["end"]?[0] ?? 0;
          final y2 = obj["y2"] ?? obj["end"]?[1] ?? 0;

          objects.add(
            DimensionObject(
              id: obj["id"] ?? UniqueKey().toString(),
              start: Offset(x1.toDouble(), y1.toDouble()),
              end: Offset(x2.toDouble(), y2.toDouble()),
              value: obj["value"] ?? "",
            ),
          );

          break;
      }
    }

    return objects;
  }
}
