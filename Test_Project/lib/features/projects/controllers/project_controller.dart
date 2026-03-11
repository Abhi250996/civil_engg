import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';

class ProjectController extends GetxController {
  final ProjectRepository _repository = ProjectRepository();

  /// =========================
  /// STATE
  /// =========================

  final RxBool isLoading = false.obs;

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;

  /// =========================
  /// LOAD PROJECTS
  /// =========================

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;

      List<ProjectModel> result = await _repository.getProjects();

      projects.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load projects");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// CREATE PROJECT
  /// =========================

  Future<void> createProject({
    required String name,
    required String description,
    required double length,
    required double width,
  }) async {
    try {
      isLoading.value = true;

      ProjectModel project = await _repository.createProject(
        name: name,
        description: description,
        length: length,
        width: width,
      );

      projects.add(project);

      Get.back();

      Get.snackbar("Success", "Project created successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to create project");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// DELETE PROJECT
  /// =========================

  Future<void> deleteProject(String projectId) async {
    try {
      await _repository.deleteProject(projectId);

      projects.removeWhere((project) => project.id == projectId);

      Get.snackbar("Success", "Project deleted");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete project");
    }
  }

  /// =========================
  /// OPEN PROJECT
  /// =========================

  void openProject(ProjectModel project) {
    Get.toNamed(RouteConstants.projectDetail, arguments: project);
  }
}
