import 'package:get/get.dart';
import 'package:build_pro/features/field_tools/controllers/field_tools_controller.dart';

class FieldToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FieldToolsController>(() => FieldToolsController());
  }
}
