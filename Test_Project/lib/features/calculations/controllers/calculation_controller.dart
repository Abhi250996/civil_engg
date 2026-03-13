import 'package:get/get.dart';
import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/ai_repository.dart';
import 'package:flutter/material.dart';

class CalculationController extends GetxController {
  final AiRepository _aiRepository = AiRepository();

  final RxBool isLoading = false.obs;
  final RxString statusMessage = "".obs;
  final RxString imageUrl = "".obs;
  final RxDouble currentZoom = 1.0.obs;
  final TransformationController transController = TransformationController();
  // Drawing Metrics
  final RxDouble buildableArea = 0.0.obs;

  final List<Map<String, dynamic>> structureTypes = [
    {"title": "Building / House", "icon": Icons.home_work, "type": "building"},
    {"title": "Industrial Plant", "icon": Icons.factory, "type": "plant"},
    {"title": "Factory Layout", "icon": Icons.precision_manufacturing, "type": "factory"},
    {"title": "Road Layout", "icon": Icons.alt_route, "type": "road"},
    {"title": "Chimney", "icon": Icons.vertical_align_top, "type": "chimney"},
    {"title": "Foundation", "icon": Icons.foundation, "type": "foundation"},
    {"title": "Water Tank", "icon": Icons.water, "type": "tank"},
    {"title": "Custom Structure", "icon": Icons.architecture, "type": "custom"},
  ];

  void openStructure(ProjectModel? project, String type) {
    Get.toNamed(
      RouteConstants.houseInput,
      arguments: {"project": project, "type": type},
    );
  }

  /// =============================================
  /// GENERATE DRAWING (Universal for All Types)
  /// =============================================
  Future<void> generateDrawingFromInputs({
    required String type,
    required Map<String, dynamic> inputData,
  }) async {
    try {
      isLoading.value = true;
      statusMessage.value = "Saving project parameters...";

      String aiPrompt = "";

      // 1. Logic for BUILDING
      if (type == "building") {
        double l = double.tryParse(inputData['length'].toString()) ?? 0;
        double w = double.tryParse(inputData['width'].toString()) ?? 0;
        double fs = double.tryParse(inputData['frontSetback'].toString()) ?? 0;
        double ss = double.tryParse(inputData['sideSetback'].toString()) ?? 0;

        // Calculate Buildable Area
        buildableArea.value = (w - (2 * ss)) * (l - fs - 1.5);

        aiPrompt = """
          Task: Professional 2D Architectural Floor Plan.
          Structure: Residential Building ($type).
          Plot Size: ${l}m x ${w}m. Orientation: ${inputData['orientation']}.
          Requirements: ${inputData['rooms']} BHK, ${inputData['floors']} Floors.
          Setbacks: Front ${fs}m, Sides ${ss}m.
          Style: Technical blueprint, black and white, high precision.
        """;
      }

      // 2. Logic for ROAD
      else if (type == "road") {
        aiPrompt = """
          Task: Technical Road Layout & Cross-Section.
          Road Length: ${inputData['length']} km.
          Carriageway Width: ${inputData['width']} m.
          Pavement Thickness: ${inputData['thickness']} mm.
          Style: Engineering civil drawing with layers detail.
        """;
      }

      // 3. Logic for INDUSTRIAL / FACTORY
      else if (type == "factory" || type == "plant") {
        aiPrompt = """
          Task: Industrial Shed & Factory Layout.
          Dimensions: ${inputData['length']}m x ${inputData['width']}m.
          Structural Load: ${inputData['load']} Tons/m2.
          Style: Industrial architectural plan with machinery placement zones.
        """;
      }

      statusMessage.value = "AI is drafting your $type plan...";

      // Call Repository
      final response = await _aiRepository.generateDrawing(
        inputData: {
          "prompt": aiPrompt,
          "meta_data": inputData, // Full data sent to repo
        },
      );

      if (response != null && response["image"] != null) {
        imageUrl.value = response["image"];
        statusMessage.value = "Drawing Ready!";
        Get.toNamed(RouteConstants.drawingResult);
      } else {
        throw "Failed to get image from AI";
      }

    } catch (e) {
      statusMessage.value = "Error: $e";
      print("AI drawing error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateZoom(double scale) {
    currentZoom.value = scale;
  }

  void resetZoom() {
    transController.value = Matrix4.identity();
    currentZoom.value = 1.0;
  }

  @override
  void onClose() {
    transController.dispose();
    super.onClose();
  }
}