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

  /// =========================
  /// STRUCTURE TYPES
  /// =========================

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
    {"title": "Custom Structure", "icon": Icons.architecture, "type": "custom"},
  ];

  /// =========================
  /// NAVIGATE TO INPUT SCREEN
  /// =========================

  void openStructure(ProjectModel? project, String type) {
    Get.toNamed(
      RouteConstants.houseInput,
      arguments: {"project": project, "type": type},
    );
  }

  /// =========================
  /// GENERATE AI DRAWING
  /// =========================

  Future<void> generateAIDrawing(String prompt) async {
    try {
      isLoading.value = true;

      final response = await _aiRepository.generateDrawing(
        inputData: {"prompt": prompt},
      );

      imageUrl.value = response["image"];
    } catch (e) {
      print("AI drawing error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
