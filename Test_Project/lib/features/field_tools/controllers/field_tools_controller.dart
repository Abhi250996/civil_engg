import 'dart:async';

import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/route_constants.dart';

class FieldToolsController extends GetxController {
  final RxDouble levelX = 0.0.obs;
  final RxDouble levelY = 0.0.obs;

  StreamSubscription? sensorSub;

  /// =========================
  /// MEASUREMENT TOOL
  /// =========================

  void openMeasurement() {
    Get.toNamed(RouteConstants.measurement);
  }

  /// =========================
  /// LEVEL TOOL
  /// =========================

  void openLevelTool() {
    Get.toNamed(RouteConstants.levelTool);

    sensorSub = accelerometerEvents.listen((event) {
      levelX.value = event.x;
      levelY.value = event.y;
    });
  }

  /// =========================
  /// GPS TOOL
  /// =========================

  Future<void> openGpsTool() async {
    Position position = await Geolocator.getCurrentPosition();

    Get.snackbar(
      "GPS Location",
      "Lat: ${position.latitude}, Lng: ${position.longitude}",
    );
  }

  /// =========================
  /// CAMERA
  /// =========================

  Future<void> openCamera() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Get.snackbar("Photo Captured", image.path);
    }
  }

  @override
  void onClose() {
    sensorSub?.cancel();
    super.onClose();
  }
}
