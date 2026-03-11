import 'package:get/get.dart';

import '../features/ai_assistant/controllers/ai_controller.dart';

class AiBinding extends Bindings {
  @override
  void dependencies() {
    /// AI Controller
    Get.lazyPut<AiController>(() => AiController(), fenix: true);
  }
}
