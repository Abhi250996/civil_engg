import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/route_constants.dart';

class FieldToolsController extends GetxController {
  final TextEditingController projectController = TextEditingController();
  final TextEditingController engineerController = TextEditingController();
  final TextEditingController labourController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController issuesController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final RxBool showLaser = false.obs;

  /// =============================
  /// LEVEL TOOL
  /// =============================

  final RxDouble levelX = 0.0.obs;
  final RxDouble levelY = 0.0.obs;

  StreamSubscription<AccelerometerEvent>? sensorSub;

  void openMeasurement() {
    Get.toNamed(RouteConstants.measurement);
  }

  void openLevelTool() {
    Get.toNamed(RouteConstants.levelTool);

    sensorSub?.cancel();

    sensorSub = accelerometerEvents.listen((event) {
      levelX.value = event.x;
      levelY.value = event.y;
    });
  }

  void stopLevelTool() {
    sensorSub?.cancel();
  }

  /// =============================
  /// GPS TOOL
  /// =============================

  Future<void> openGpsTool() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar("Location Disabled", "Please enable GPS services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Location permission permanently denied",
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Get.snackbar(
        "Site Coordinates",
        "Lat: ${position.latitude.toStringAsFixed(6)}\nLng: ${position.longitude.toStringAsFixed(6)}",
      );
    } catch (e) {
      Get.snackbar("GPS Error", e.toString());
    }
  }

  /// =============================
  /// UNIT CONVERTER
  /// =============================

  void openUnitConverter() {
    Get.toNamed(RouteConstants.unitConverter);
  }

  /// =============================
  /// CONCRETE CALCULATOR
  /// =============================

  double calculateConcreteVolume(double length, double width, double depth) {
    return length * width * depth;
  }

  void openConcreteCalc() {
    Get.toNamed(RouteConstants.concreteCalc);
  }

  /// =============================
  /// STEEL CALCULATOR
  /// =============================

  double calculateSteelWeight(double diameter, double length) {
    return (diameter * diameter / 162) * length;
  }

  void openSteelCalc() {
    Get.toNamed(RouteConstants.steelCalc);
  }

  /// =============================
  /// SLOPE CALCULATOR
  /// =============================

  double calculateSlope(double rise, double run) {
    if (run == 0) return 0;
    return rise / run;
  }

  void toggleLaser() {
    showLaser.value = !showLaser.value;
  }

  void resetCalibration() {
    levelX.value = 0;
    levelY.value = 0;
  }

  void holdMeasurement() {
    Get.snackbar("Measurement", "Angle locked");
  }

  /// =============================
  /// CAMERA TOOL
  /// =============================

  final Rx<File?> capturedImage = Rx<File?>(null);

  Future<void> openCamera() async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        capturedImage.value = File(image.path);

        Get.snackbar("Photo Captured", "Saved to site media gallery");
      }
    } catch (e) {
      Get.snackbar("Camera Error", e.toString());
    }
  }

  /// =============================
  /// SITE DIARY STATE
  /// =============================

  final RxString location = "Location not captured".obs;

  final RxString weather = "Sunny".obs;

  /// =============================
  /// CAPTURE LOCATION
  /// =============================

  Future<void> captureLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar("GPS Disabled", "Enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition();

      location.value =
          "Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}";
    } catch (e) {
      Get.snackbar("Location Error", e.toString());
    }
  }

  /// =============================
  /// SAVE SITE DIARY ENTRY
  /// =============================

  void saveSiteDiaryEntry() {
    final entry = {
      "project": projectController.text,
      "engineer": engineerController.text,
      "weather": weather.value,
      "workers": labourController.text,
      "work_done": workController.text,
      "issues": issuesController.text,
      "notes": notesController.text,
      "location": location.value,
      "photo": capturedImage.value?.path,
      "timestamp": DateTime.now().toIso8601String(),
    };

    /// DEBUG (Later send to Firebase)
    print("Site Diary Entry: $entry");

    Get.snackbar("Saved", "Site diary entry saved successfully");

    clearDiaryForm();
  }

  /// =============================
  /// CLEAR FORM
  /// =============================

  void clearDiaryForm() {
    projectController.clear();
    engineerController.clear();
    labourController.clear();
    workController.clear();
    issuesController.clear();
    notesController.clear();

    capturedImage.value = null;
    location.value = "Location not captured";
  }

  /// =============================
  /// NAVIGATION
  /// =============================

  void openSiteDiary() {
    Get.toNamed(RouteConstants.siteDiary);
  }

  void openCadViewer() {
    Get.toNamed(RouteConstants.cadViewer);
  }

  void openSunSeeker() {
    Get.toNamed(RouteConstants.sunPath);
  }

  /// =============================
  /// CLEANUP
  /// =============================

  @override
  void onClose() {
    sensorSub?.cancel();
    super.onClose();
  }
}
