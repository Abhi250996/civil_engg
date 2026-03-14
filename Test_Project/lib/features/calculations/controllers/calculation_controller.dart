import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

  /// STRUCTURE TYPES GRID
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

  /// OPEN INPUT SCREEN
  void openStructure(ProjectModel? project, String type) {
    Get.toNamed(
      RouteConstants.houseInput,
      arguments: {"project": project, "type": type},
    );
  }

  /// ======================================================
  /// MAIN DRAWING GENERATOR
  /// ======================================================
  Future<void> generateDrawingFromInputs({
    required String type,
    required Map<String, dynamic> inputData,
  }) async {
    try {
      isLoading.value = true;
      statusMessage.value = "Preparing engineering parameters...";

      /// EXTRACT STRUCTURED DATA

      final project = inputData["project"] ?? {};
      final site = inputData["site"] ?? {};
      final regulations = inputData["regulations"] ?? {};
      final building = inputData["building"] ?? {};
      final structure = inputData["structure"] ?? {};
      final drawing = inputData["drawing"] ?? {};

      double length = double.tryParse(site["length"]?.toString() ?? "0") ?? 0;
      double width = double.tryParse(site["width"]?.toString() ?? "0") ?? 0;

      double frontSetback =
          double.tryParse(regulations["frontSetback"]?.toString() ?? "0") ?? 0;

      double sideSetback =
          double.tryParse(regulations["sideSetback"]?.toString() ?? "0") ?? 0;

      /// BUILDABLE AREA CALCULATION

      if (length > 0 && width > 0) {
        buildableArea.value =
            (width - (2 * sideSetback)) * (length - frontSetback);
      }

      String aiPrompt = "";

      /// ======================================================
      /// BUILDING PROMPT
      /// ======================================================

      if (type == "building") {
        aiPrompt =
            """
Task: Professional Architectural Floor Plan

Project: ${project["name"]}
Location: ${project["location"]}

Plot Dimensions: ${length}m x ${width}m
Orientation: ${site["orientation"]}

Regulations:
Front Setback: ${regulations["frontSetback"]} m
Rear Setback: ${regulations["rearSetback"]} m
Side Setback: ${regulations["sideSetback"]} m

Building Program:
Floors: ${building["floors"]}
Rooms: ${building["rooms"]} BHK
Floor Height: ${building["floorHeight"]} m

Structural Inputs:
Soil Bearing Capacity: ${structure["soilBearingCapacity"]} kN/m²
Seismic Zone: ${structure["seismicZone"]}

Drawing Settings:
Scale: ${drawing["scale"]}
Sheet Size: ${drawing["sheetSize"]}
Detail Level: ${drawing["detailLevel"]}

Output:
Professional dimensioned blueprint style architectural floor plan
with walls, rooms, circulation spaces, structural grid, and annotations.
""";
      }
      /// ======================================================
      /// ROAD PROMPT
      /// ======================================================
      else if (type == "road") {
        aiPrompt =
            """
Task: Civil Engineering Road Layout Drawing

Project: ${project["name"]}
Location: ${project["location"]}

Road Length: ${site["length"]} km
Carriageway Width: ${site["width"]} m
Pavement Thickness: ${structure["thickness"] ?? "200"} mm

Design Conditions:
Soil Bearing Capacity: ${structure["soilBearingCapacity"]}

Output:
Professional civil engineering road layout with cross-section,
layered pavement structure, drainage, and dimensions.
""";
      }
      /// ======================================================
      /// INDUSTRIAL PROMPT
      /// ======================================================
      else if (type == "factory" || type == "plant") {
        aiPrompt =
            """
Task: Industrial Building Layout

Project: ${project["name"]}
Location: ${project["location"]}

Building Size: ${length}m x ${width}m
Structural Load Capacity: ${structure["designLoad"]} tons/m²

Output:
Industrial factory layout with machinery zones,
structural grid, ventilation spaces and loading areas.
""";
      }
      /// ======================================================
      /// DEFAULT PROMPT
      /// ======================================================
      else {
        aiPrompt =
            """
Task: Civil Engineering Structure Layout

Structure Type: $type

Site Size:
Length: $length m
Width: $width m

Create a professional engineering layout drawing with
clear structural geometry, annotations, and blueprint style.
""";
      }

      statusMessage.value = "AI is generating the professional drawing...";

      /// CALL AI SERVICE

      final response = await _aiRepository.generateDrawing(
        inputData: {"prompt": aiPrompt, "meta_data": inputData},
      );

      if (response != null && response["image"] != null) {
        imageUrl.value = response["image"];

        statusMessage.value = "Drawing Generated Successfully";

        Get.toNamed(RouteConstants.drawingResult);
      } else {
        throw "AI returned invalid drawing data";
      }
    } catch (e) {
      statusMessage.value = "Error generating drawing";

      debugPrint("AI Drawing Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ======================================================
  /// VIEWER CONTROLS
  /// ======================================================

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
