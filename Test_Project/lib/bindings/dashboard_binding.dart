import 'package:get/get.dart';

import '../features/dashboard/controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    /// Dashboard Controller
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }
}
