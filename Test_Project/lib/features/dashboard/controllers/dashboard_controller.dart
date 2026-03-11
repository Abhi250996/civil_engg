import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final AuthController _authController = Get.find();

  /// =========================
  /// NAVIGATION
  /// =========================

  void openProjects() {
    Get.toNamed(RouteConstants.projects);
  }

  void openCalculations() {
    Get.toNamed(RouteConstants.calculationType);
  }

  void openFieldTools() {
    Get.toNamed(RouteConstants.fieldTools);
  }

  void openAiAssistant() {
    Get.toNamed(RouteConstants.aiChat);
  }

  void openReports() {
    Get.toNamed(RouteConstants.reports);
  }

  /// =========================
  /// LOGOUT
  /// =========================

  void logout() {
    _authController.logout();
  }
}
