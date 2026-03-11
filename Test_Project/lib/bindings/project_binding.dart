import 'package:get/get.dart';

import '../features/projects/controllers/project_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    /// Project Controller
    Get.lazyPut<ProjectController>(() => ProjectController(), fenix: true);
  }
}
