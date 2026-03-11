import 'package:get/get.dart';

import '../features/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    /// Authentication Controller
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
