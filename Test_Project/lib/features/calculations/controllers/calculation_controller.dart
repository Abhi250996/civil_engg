import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/ai_repository.dart';

class CalculationController extends GetxController {
  final AiRepository _aiRepository = AiRepository();

  final RxBool isLoading = false.obs;
  final RxString statusMessage = "".obs;
  final RxString imageUrl = "".obs;

  final RxDouble currentZoom = 1.0.obs;
  final TransformationController transController = TransformationController();

  final RxDouble buildableArea = 0.0.obs;

  /// MATERIAL ESTIMATION
  final RxDouble estimatedConcrete = 0.0.obs;
  final RxDouble estimatedSteel = 0.0.obs;

  /// ================================
  /// ALL STRUCTURE TYPES RESTORED
  /// ================================

  final List<Map<String, dynamic>> structureTypes = [
    {"title": "Building / House", "icon": Icons.home_work, "type": "building"},

    {"title": "Industrial Plant", "icon": Icons.factory, "type": "plant"},

    {
      "title": "Factory Layout",
      "icon": Icons.precision_manufacturing,
      "type": "factory",
    },

    {"title": "Road Layout", "icon": Icons.alt_route, "type": "road"},

    {"title": "Chimney", "icon": Icons.vertical_align_top, "type": "chimney"},

    {"title": "Foundation", "icon": Icons.foundation, "type": "foundation"},

    {"title": "Water Tank", "icon": Icons.water, "type": "tank"},

    {"title": "Bridge / Overpass", "icon": Icons.edit_road, "type": "bridge"},

    {"title": "Tunnel", "icon": Icons.vignette, "type": "tunnel"},

    {
      "title": "Retaining Wall",
      "icon": Icons.reorder,
      "type": "retaining_wall",
    },

    {"title": "Dam / Levee", "icon": Icons.waves, "type": "dam"},

    {
      "title": "Power Line / Tower",
      "icon": Icons.electrical_services,
      "type": "tower",
    },

    {"title": "Pipeline", "icon": Icons.polyline, "type": "pipeline"},

    {"title": "Solar Farm", "icon": Icons.solar_power, "type": "solar"},

    {
      "title": "Cooling Tower",
      "icon": Icons.heat_pump,
      "type": "cooling_tower",
    },

    {"title": "Telecom Tower", "icon": Icons.sensors, "type": "telecom"},

    {"title": "Warehouse", "icon": Icons.inventory_2, "type": "warehouse"},

    {"title": "Silo / Storage", "icon": Icons.storage, "type": "silo"},

    {"title": "Parking Lot", "icon": Icons.local_parking, "type": "parking"},

    {"title": "Fence / Boundary", "icon": Icons.fence, "type": "fence"},

    {"title": "Custom Structure", "icon": Icons.architecture, "type": "custom"},
  ];

  /// ================================
  /// UNIT CONVERSION
  /// ================================

  double convertToMeter(double value, String unit) {
    switch (unit) {
      case "mm":
        return value / 1000;

      case "cm":
        return value / 100;

      case "m":
        return value;

      case "inch":
        return value * 0.0254;

      case "ft":
        return value * 0.3048;

      case "yard":
        return value * 0.9144;

      default:
        return value;
    }
  }

  /// ================================
  /// OPEN INPUT SCREEN
  /// ================================

  void openStructure(ProjectModel? project, String type) {
    switch (type) {
      case "building":
        Get.toNamed(
          RouteConstants.buildingInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "road":
        Get.toNamed(
          RouteConstants.roadInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "bridge":
        Get.toNamed(
          RouteConstants.bridgeInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "tank":
        Get.toNamed(
          RouteConstants.tankInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "pipeline":
        Get.toNamed(
          RouteConstants.pipelineInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "chimney":
        Get.toNamed(
          RouteConstants.chimneyInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "foundation":
        Get.toNamed(
          RouteConstants.foundationInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "tunnel":
        Get.toNamed(
          RouteConstants.tunnelInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "retaining_wall":
        Get.toNamed(
          RouteConstants.retainingWallInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "dam":
        Get.toNamed(
          RouteConstants.damInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "tower":
        Get.toNamed(
          RouteConstants.towerInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "solar":
        Get.toNamed(
          RouteConstants.solarFarmInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "cooling_tower":
        Get.toNamed(
          RouteConstants.coolingTowerInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "telecom":
        Get.toNamed(
          RouteConstants.telecomTowerInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "warehouse":
        Get.toNamed(
          RouteConstants.warehouseInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "silo":
        Get.toNamed(
          RouteConstants.siloInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "parking":
        Get.toNamed(
          RouteConstants.parkingInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "fence":
        Get.toNamed(
          RouteConstants.fenceInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "plant":
        Get.toNamed(
          RouteConstants.plantInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "factory":
        Get.toNamed(
          RouteConstants.factoryInput,
          arguments: {"project": project, "type": type},
        );
        break;

      case "custom":
        Get.toNamed(
          RouteConstants.customStructureInput,
          arguments: {"project": project, "type": type},
        );
        break;

      default:
        Get.toNamed(
          RouteConstants.buildingInput,
          arguments: {"project": project, "type": type},
        );
    }
  }

  /// ================================
  /// MAIN AI GENERATION FUNCTION
  /// ================================

  Future<void> generateDrawingFromInputs({
    required String type,
    required Map<String, dynamic> inputData,
  }) async {
    try {
      isLoading.value = true;
      statusMessage.value = "Analyzing engineering inputs...";

      print("INPUT DATA: $inputData");

      /// =============================
      /// BASIC DIMENSIONS
      /// =============================

      double length = 0;
      double width = 0;
      double height = 0;

      /// BUILDING
      if (type == "building") {
        length = double.tryParse(inputData["plotLength"] ?? "0") ?? 0;
        width = double.tryParse(inputData["plotWidth"] ?? "0") ?? 0;
        height = double.tryParse(inputData["floorHeight"] ?? "0") ?? 0;
      }

      /// ROAD
      if (type == "road") {
        length = double.tryParse(inputData["roadLength"] ?? "0") ?? 0;
        width = double.tryParse(inputData["carriagewayWidth"] ?? "0") ?? 0;
      }

      /// BRIDGE
      if (type == "bridge") {
        length = double.tryParse(inputData["spanLength"] ?? "0") ?? 0;
        width = double.tryParse(inputData["deckWidth"] ?? "0") ?? 0;
      }

      /// TANK
      if (type == "tank") {
        width = double.tryParse(inputData["diameter"] ?? "0") ?? 0;
        height = double.tryParse(inputData["height"] ?? "0") ?? 0;
      }

      /// PIPELINE
      if (type == "pipeline") {
        width = double.tryParse(inputData["diameter"] ?? "0") ?? 0;
        length = double.tryParse(inputData["length"] ?? "0") ?? 0;
      }

      /// TELECOM TOWER
      if (type == "telecom") {
        height = double.tryParse(inputData["height"] ?? "0") ?? 0;
        width = double.tryParse(inputData["baseWidth"] ?? "0") ?? 0;
      }

      /// WAREHOUSE
      if (type == "warehouse") {
        length = double.tryParse(inputData["length"] ?? "0") ?? 0;
        width = double.tryParse(inputData["width"] ?? "0") ?? 0;
      }

      /// RETAINING WALL
      if (type == "retaining_wall") {
        height = double.tryParse(inputData["wallHeight"] ?? "0") ?? 0;
        width = double.tryParse(inputData["baseWidth"] ?? "0") ?? 0;
      }

      /// CHIMNEY
      if (type == "chimney") {
        height = double.tryParse(inputData["height"] ?? "0") ?? 0;
        width = double.tryParse(inputData["diameter"] ?? "0") ?? 0;
      }

      /// =============================
      /// BUILDABLE AREA
      /// =============================

      if (length > 0 && width > 0) {
        buildableArea.value = length * width;
      }

      /// =============================
      /// GRID GENERATION
      /// =============================

      int gridX = length > 0 ? (length / 5).ceil() : 0;
      int gridY = width > 0 ? (width / 5).ceil() : 0;

      /// =============================
      /// MATERIAL ESTIMATION
      /// =============================

      double area = length * width;

      estimatedConcrete.value = area * 0.12;
      estimatedSteel.value = estimatedConcrete.value * 80;

      /// =============================
      /// AI PROMPT
      /// =============================

      String aiPrompt =
          """
Civil Engineering Technical Drawing

Structure Type: $type

Dimensions:

Length: ${length.toStringAsFixed(2)} meters
Width: ${width.toStringAsFixed(2)} meters
Height: ${height.toStringAsFixed(2)} meters

Generate a professional engineering blueprint.

Include:

• Structural layout
• Dimension labels with units (meters)
• Engineering annotations
• Technical drawing style
""";

      /// Building specific
      if (type == "building") {
        aiPrompt +=
            """

Also include:

• Floor plan
• Room layout
• Column grid (${gridX} x ${gridY})
""";
      }

      /// Bridge specific
      if (type == "bridge") {
        aiPrompt += """

Include:

• Bridge deck
• Pier locations
• Structural supports
""";
      }

      /// Road specific
      if (type == "road") {
        aiPrompt += """

Include:

• Road cross section
• Pavement layers
• Drainage
""";
      }

      statusMessage.value = "AI generating engineering drawing...";

      /// =============================
      /// CALL AI
      /// =============================

      final response = await _aiRepository.generateDrawing(
        inputData: {"prompt": aiPrompt, "meta_data": inputData},
      );

      if (response["image"] != null) {
        imageUrl.value = response["image"];
        statusMessage.value = "Drawing Generated Successfully";
        Get.toNamed(RouteConstants.drawingResult);
      } else {
        throw "AI returned invalid drawing";
      }
    } catch (e) {
      statusMessage.value = "Error generating drawing";
      debugPrint("AI Drawing Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================================
  /// IMAGE FETCH
  /// ================================

  Future<Uint8List> getImageBytes() async {
    final url = imageUrl.value;

    if (url.startsWith("data:image")) {
      return base64Decode(url.split(',').last);
    }

    final response = await http.get(Uri.parse(url));

    return response.bodyBytes;
  }

  /// ================================
  /// VIEWER CONTROLS
  /// ================================

  void updateZoom(double scale) {
    currentZoom.value = scale;
  }

  void resetZoom() {
    transController.value = Matrix4.identity();

    currentZoom.value = 1.0;
  }

  void clearDrawing() {
    imageUrl.value = "";

    statusMessage.value = "";

    resetZoom();
  }

  @override
  void onClose() {
    transController.dispose();

    super.onClose();
  }
}
