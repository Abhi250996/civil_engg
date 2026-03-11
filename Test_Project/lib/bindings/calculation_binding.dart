import 'package:get/get.dart';

import '../features/calculations/controllers/calculation_controller.dart';

class CalculationBinding extends Bindings {
  @override
  void dependencies() {
    /// Calculation Controller
    Get.lazyPut<CalculationController>(
      () => CalculationController(),
      fenix: true,
    );
  }
}
