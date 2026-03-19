import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/route_constants.dart';

class FieldToolsController extends GetxController {
  /// ======================================================
  /// SITE DIARY TEXT CONTROLLERS
  /// ======================================================

  final projectController = TextEditingController();
  final engineerController = TextEditingController();
  final labourController = TextEditingController();
  final workController = TextEditingController();
  final issuesController = TextEditingController();
  final notesController = TextEditingController();

  /// ======================================================
  /// DIARY STORAGE (LOCAL MEMORY)
  /// ======================================================

  final RxList<Map<String, dynamic>> diaryEntries =
      <Map<String, dynamic>>[].obs;

  /// ======================================================
  /// LEVEL TOOL STATE
  /// ======================================================

  final RxDouble levelX = 0.0.obs;
  final RxDouble levelY = 0.0.obs;

  final RxBool showLaser = false.obs;
  final RxBool holdMode = false.obs;

  double calibrationX = 0;
  double calibrationY = 0;

  StreamSubscription<AccelerometerEvent>? sensorSub;

  /// START SENSOR
  void startLevelSensor() {
    sensorSub?.cancel();

    sensorSub = accelerometerEvents.listen((event) {
      if (holdMode.value) return;

      levelX.value = event.x - calibrationX;
      levelY.value = event.y - calibrationY;
    });
  }

  /// STOP SENSOR
  void stopLevelSensor() {
    sensorSub?.cancel();
  }

  /// OPEN LEVEL TOOL
  void openLevelTool() {
    Get.toNamed(RouteConstants.levelTool);
  }

  /// RESET CALIBRATION
  void resetCalibration() {
    calibrationX = levelX.value;
    calibrationY = levelY.value;

    Get.snackbar(
      "Calibration",
      "Current surface set as level reference",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// HOLD MEASUREMENT
  void holdMeasurement() {
    holdMode.value = !holdMode.value;

    Get.snackbar(
      "Hold Mode",
      holdMode.value ? "Measurement Locked" : "Measurement Released",
    );
  }

  /// LASER LINE
  void toggleLaser() {
    showLaser.value = !showLaser.value;
  }

  /// ======================================================
  /// MEASUREMENT TOOL NAVIGATION
  /// ======================================================

  void openMeasurement() {
    Get.toNamed(RouteConstants.measurement);
  }

  /// ======================================================
  /// NEW TOOLS
  /// ======================================================

  /// AREA CALCULATOR
  void openAreaTool() {
    Get.toNamed(RouteConstants.areaCalc);
  }

  /// SLOPE CALCULATOR
  void openSlopeTool() {
    Get.toNamed(RouteConstants.slopeCalc);
  }

  /// ======================================================
  /// GPS TOOL
  /// ======================================================

  Future<void> openGpsTool() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        Get.snackbar("GPS Disabled", "Please enable GPS services");
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

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Get.snackbar(
        "Coordinates",
        "Lat: ${pos.latitude.toStringAsFixed(6)}\nLng: ${pos.longitude.toStringAsFixed(6)}",
      );
    } catch (e) {
      Get.snackbar("GPS Error", e.toString());
    }
  }

  /// ======================================================
  /// CAMERA TOOL
  /// ======================================================

  final Rx<File?> capturedImage = Rx<File?>(null);

  Future<void> openCamera() async {
    try {
      final picker = ImagePicker();

      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        capturedImage.value = File(photo.path);

        Get.snackbar("Photo Captured", "Image saved successfully");
      }
    } catch (e) {
      Get.snackbar("Camera Error", e.toString());
    }
  }

  /// ======================================================
  /// LOCATION CAPTURE
  /// ======================================================

  final RxString location = "Location not captured".obs;
  final RxString weather = "Sunny".obs;

  Future<void> captureLocation() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        Get.snackbar("GPS Disabled", "Enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) return;

      Position pos = await Geolocator.getCurrentPosition();

      location.value =
          "Lat: ${pos.latitude.toStringAsFixed(5)}, Lng: ${pos.longitude.toStringAsFixed(5)}";
    } catch (e) {
      Get.snackbar("Location Error", e.toString());
    }
  }

  /// ======================================================
  /// SAVE SITE DIARY ENTRY
  /// ======================================================

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
      "photo": capturedImage.value,
      "timestamp": DateTime.now(),
    };

    diaryEntries.add(entry);

    Get.snackbar("Saved", "Site diary entry saved successfully");

    clearDiaryForm();
  }

  /// ======================================================
  /// DELETE DIARY ENTRY
  /// ======================================================

  void deleteEntry(int index) {
    diaryEntries.removeAt(index);

    Get.snackbar("Deleted", "Entry removed");
  }

  /// ======================================================
  /// CLEAR FORM
  /// ======================================================

  void clearDiaryForm() {
    projectController.clear();
    engineerController.clear();
    labourController.clear();
    workController.clear();
    issuesController.clear();
    notesController.clear();

    capturedImage.value = null;

    location.value = "Location not captured";
    weather.value = "Sunny";
  }

  /// ======================================================
  /// NAVIGATION
  /// ======================================================

  void openUnitConverter() => Get.toNamed(RouteConstants.unitConverter);

  void openConcreteCalc() => Get.toNamed(RouteConstants.concreteCalc);

  void openSteelCalc() => Get.toNamed(RouteConstants.steelCalc);

  void openSiteDiary() => Get.toNamed(RouteConstants.siteDiary);

  void openCadViewer() => Get.toNamed(RouteConstants.cadViewer);

  void openSunSeeker() => Get.toNamed(RouteConstants.sunPath);

  /// ======================================================
  /// CLEANUP
  /// ======================================================

  @override
  void onClose() {
    sensorSub?.cancel();

    projectController.dispose();
    engineerController.dispose();
    labourController.dispose();
    workController.dispose();
    issuesController.dispose();
    notesController.dispose();

    super.onClose();
  }
}
