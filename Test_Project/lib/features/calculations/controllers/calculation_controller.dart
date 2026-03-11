import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test_project/core/services/dxf_export_service.dart';

import '../../../data/repositories/ai_repository.dart';

import '../../drawing_engine/drawing_object.dart';
import '../../drawing_engine/line_object.dart';
import '../../drawing_engine/circle_object.dart';
import '../../drawing_engine/rectangle_object.dart';
import '../../drawing_engine/text_object.dart';
import '../../drawing_engine/pipe_object.dart';
import '../../drawing_engine/dimension_object.dart';
import '../../drawing_engine/equipment_object.dart';
import '../../drawing_engine/drawing_json_parser.dart';

class CalculationController extends GetxController {
  final AiRepository _aiRepository = AiRepository();

  /// =========================
  /// STATE
  /// =========================

  final RxList<DrawingObject> objects = <DrawingObject>[].obs;

  final RxBool isLoading = false.obs;

  final RxString statusMessage = "".obs;

  /// =========================
  /// CLEAR DRAWING
  /// =========================

  void clearDrawing() {
    objects.clear();
  }

  /// =========================
  /// ADD OBJECT
  /// =========================

  void addObject(DrawingObject object) {
    objects.add(object);
  }

  /// =========================
  /// AI DRAWING GENERATION
  /// =========================
  Future<void> generateAIDrawing(String prompt) async {
    try {
      isLoading.value = true;

      clearDrawing();

      final response = await _aiRepository.generateDrawing(
        inputData: {"prompt": prompt},
      );

      final parsedObjects = DrawingJsonParser.parse(response);

      objects.assignAll(parsedObjects);
    } catch (e) {
      print("AI drawing error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// TEST PLANT LAYOUT
  /// =========================

  void generateTestPlantLayout() {
    clearDrawing();

    addObject(
      RectangleObject(
        id: "building1",
        rect: const Rect.fromLTWH(100, 100, 300, 200),
        label: "Plant Building",
      ),
    );

    addObject(
      CircleObject(
        id: "tank1",
        center: const Offset(200, 350),
        radius: 40,
        label: "Tank",
      ),
    );

    addObject(
      EquipmentObject(
        id: "pump1",
        position: const Offset(400, 350),
        type: EquipmentType.pump,
        label: "Pump",
      ),
    );

    addObject(
      PipeObject(
        id: "pipe1",
        start: const Offset(240, 350),
        end: const Offset(380, 350),
        pipeLabel: "Steam Line",
      ),
    );

    addObject(
      LineObject(
        id: "wall1",
        start: const Offset(100, 100),
        end: const Offset(400, 100),
      ),
    );

    addObject(
      DimensionObject(
        id: "dim1",
        start: const Offset(100, 80),
        end: const Offset(400, 80),
        value: "30 m",
      ),
    );

    addObject(
      TextObject(
        id: "label1",
        position: const Offset(200, 60),
        text: "Plant Layout Example",
      ),
    );

    objects.refresh();
  }

  /// =========================
  /// EXPORT DRAWING
  /// =========================

  Future<void> exportDrawing() async {
    try {
      if (objects.isEmpty) {
        statusMessage.value = "Nothing to export";
        return;
      }

      statusMessage.value = "Exporting DXF...";

      final file = await DxfExportService.exportDXF(objects);

      statusMessage.value = "DXF saved: ${file.path}";

      print("DXF saved: ${file.path}");
    } catch (e) {
      statusMessage.value = "Export failed";
      print("DXF export error: $e");
    }
  }
}
