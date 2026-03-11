import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';

class FieldToolsController extends GetxController {
  /// =========================
  /// OPEN MEASUREMENT TOOL
  /// =========================

  void openMeasurement() {
    Get.toNamed(RouteConstants.measurement);
  }

  /// =========================
  /// OPEN LEVEL TOOL
  /// =========================

  void openLevelTool() {
    Get.snackbar("Level Tool", "Level measurement feature coming soon");
  }

  /// =========================
  /// OPEN GPS TOOL
  /// =========================

  void openGpsTool() {
    Get.snackbar("GPS Mapping", "GPS mapping feature coming soon");
  }

  /// =========================
  /// OPEN CAMERA
  /// =========================

  void openCamera() {
    Get.snackbar("Camera", "Site photo capture feature coming soon");
  }
}
