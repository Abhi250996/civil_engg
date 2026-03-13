import 'package:get/get.dart';
import 'package:test_project/features/field_tools/controllers/field_tools_controller.dart';

class FieldToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FieldToolsController>(() => FieldToolsController());
  }
}
