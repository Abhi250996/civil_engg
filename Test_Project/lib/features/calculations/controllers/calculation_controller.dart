import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:build_pro/core/constants/prompt_builder.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/ai_repository.dart';

class CalculationController extends GetxController {
  final AiRepository _aiRepository = AiRepository();
  final List<String> unitOptions = ["meter", "feet", "inch", "centimeter"];
  var selectedUnit = "meter".obs;
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
  /// STRUCTURE TYPES
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
    {
      "title": "Thermal Chimney",
      "icon": Icons.local_fire_department,
      "type": "thermal_chimney",
    },
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
  /// OPEN INPUT SCREEN
  /// ================================
  void openStructure(ProjectModel? project, String type) {
    Get.toNamed(_getRoute(type), arguments: {"project": project, "type": type});
  }

  String _getRoute(String type) {
    switch (type) {
      case "building":
        return RouteConstants.buildingInput;
      case "road":
        return RouteConstants.roadInput;
      case "bridge":
        return RouteConstants.bridgeInput;
      case "tank":
        return RouteConstants.tankInput;
      case "pipeline":
        return RouteConstants.pipelineInput;
      case "chimney":
        return RouteConstants.chimneyInput;
      case "thermal_chimney":
        return RouteConstants.thermalChimneyInput;
      case "foundation":
        return RouteConstants.foundationInput;
      case "tunnel":
        return RouteConstants.tunnelInput;
      case "retaining_wall":
        return RouteConstants.retainingWallInput;
      case "dam":
        return RouteConstants.damInput;
      case "tower":
        return RouteConstants.towerInput;
      case "solar":
        return RouteConstants.solarFarmInput;
      case "cooling_tower":
        return RouteConstants.coolingTowerInput;
      case "telecom":
        return RouteConstants.telecomTowerInput;
      case "warehouse":
        return RouteConstants.warehouseInput;
      case "silo":
        return RouteConstants.siloInput;
      case "parking":
        return RouteConstants.parkingInput;
      case "fence":
        return RouteConstants.fenceInput;
      case "plant":
        return RouteConstants.plantInput;
      case "factory":
        return RouteConstants.factoryInput;
      default:
        return RouteConstants.buildingInput;
    }
  }

  /// ================================
  /// MAIN FUNCTION (UPDATED)
  /// ================================
  Future<Map<String, dynamic>> generateDrawingFromInputs({
    required String type,
    required Map<String, dynamic> inputData,
  }) async {
    try {
      isLoading.value = true;
      statusMessage.value = "Analyzing inputs...";

      /// ================= SAFE PARSER =================
      double parse(dynamic v) {
        if (v == null) return 0;
        return double.tryParse(v.toString()) ?? 0;
      }

      double length = 0, width = 0;

      /// ================= DIMENSION EXTRACTION =================
      switch (type) {
        case "building":
          length = parse(
            inputData["plotLength"] ?? inputData["geometry"]?["length"],
          );
          width = parse(
            inputData["plotWidth"] ?? inputData["geometry"]?["width"],
          );
          break;

        case "road":
          length = parse(inputData["geometry"]?["length"]);
          width = parse(inputData["geometry"]?["width"]);
          break;

        case "bridge":
          length = parse(inputData["geometry"]?["spanLength"]);
          width = parse(inputData["geometry"]?["width"]);
          break;

        case "tunnel":
          length = parse(inputData["geometry"]?["length"]);
          width = parse(inputData["geometry"]?["diameter"]);
          break;

        case "tank":
          width = parse(inputData["tank"]?["diameter"]);
          break;

        case "chimney":
          width = parse(inputData["diameter"]);
          break;

        case "thermal_chimney":
          width = parse(inputData["geometry"]?["diameter"]);
          break;

        case "warehouse":
          length = parse(inputData["dimensions"]?["length"]);
          width = parse(inputData["dimensions"]?["width"]);
          break;

        case "silo":
          width = parse(inputData["geometry"]?["diameter"]);
          break;

        case "solar":
        case "plant":
        case "factory":
        case "parking":
          length = parse(inputData["site"]?["length"]);
          width = parse(inputData["site"]?["width"]);
          break;

        case "pipeline":
          length = parse(inputData["pipeline"]?["length"]);
          width = parse(inputData["pipeline"]?["diameter"]);
          break;

        case "tower":
        case "telecom":
          break;

        case "dam":
          length = parse(inputData["geometry"]?["crestLength"]);
          width = parse(inputData["geometry"]?["baseWidth"]);
          break;

        case "retaining_wall":
          length = parse(inputData["geometry"]?["length"]);
          break;

        case "foundation":
          length = parse(inputData["foundation"]?["length"]);
          width = parse(inputData["foundation"]?["width"]);
          break;

        case "cooling_tower":
          width = parse(inputData["diameter"]);
          break;

        case "fence":
          length = parse(inputData["length"]);
          break;
      }

      /// ================= CALCULATIONS =================
      double area = length * width;

      buildableArea.value = area;
      estimatedConcrete.value = area * 0.12;
      estimatedSteel.value = estimatedConcrete.value * 80;

      /// ================= PROMPT =================
      final aiPrompt = PromptBuilder.build(type, inputData);

      print("TYPE: $type");
      print("INPUT: $inputData");
      print("PROMPT: $aiPrompt");

      statusMessage.value = "Generating drawing...";

      /// ================= API CALL =================
      final response = await _aiRepository.generateDrawing(
        inputData: {"prompt": aiPrompt, "meta_data": inputData},
      );

      if (response["image"] != null) {
        imageUrl.value = response["image"];
        statusMessage.value = "Drawing Generated";

        Get.toNamed(RouteConstants.drawingResult);

        return {"success": true};
      } else {
        throw "Invalid AI response";
      }
    } catch (e) {
      statusMessage.value = "Error occurred";
      print("ERROR: $e");

      return {"success": false, "message": e.toString()};
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= IMAGE =================
  Future<Uint8List> getImageBytes() async {
    final url = imageUrl.value;

    if (url.startsWith("data:image")) {
      return base64Decode(url.split(',').last);
    }

    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  /// ================= VIEW =================
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
