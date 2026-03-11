import 'package:get/get.dart';

import '../features/reports/controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    /// Report Controller
    Get.lazyPut<ReportController>(() => ReportController(), fenix: true);
  }
}
