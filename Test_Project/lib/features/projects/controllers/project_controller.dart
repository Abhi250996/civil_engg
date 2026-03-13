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

  final RxList<ProjectModel> filteredProjects = <ProjectModel>[].obs;

  /// =========================
  /// LOAD PROJECTS
  /// =========================

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;

      final result = await _repository.getProjects();

      projects.assignAll(result);
      filteredProjects.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load projects");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// REFRESH PROJECTS
  /// =========================

  Future<void> refreshProjects() async {
    await loadProjects();
  }

  /// =========================
  /// SEARCH PROJECTS
  /// =========================

  void searchProjects(String query) {
    if (query.isEmpty) {
      filteredProjects.assignAll(projects);
      return;
    }

    filteredProjects.assignAll(
      projects.where(
        (p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            (p.projectCategory ?? "").toLowerCase().contains(
              query.toLowerCase(),
            ),
      ),
    );
  }

  /// =========================
  /// CREATE PROJECT
  /// =========================

  Future<void> createProject({
    required String name,
    required String description,

    /// PROJECT CLASSIFICATION
    String? projectCategory,
    String? projectSubType,

    /// SITE INFORMATION
    double? siteArea,
    double? length,
    double? width,
    double? elevation,

    String? location,
    double? latitude,
    double? longitude,

    /// ENGINEERING PARAMETERS
    String? soilType,
    String? foundationType,
    String? structureType,
    String? materialGrade,
    String? seismicZone,
    String? designCode,

    /// MANAGEMENT
    double? budget,
    String? contractor,
    String? consultant,
    String? projectStatus,
    String? projectStage,

    /// TIMELINE
    DateTime? startDate,
    DateTime? completionDate,
  }) async {
    try {
      isLoading.value = true;

      final project = await _repository.createProject(
        name: name,
        description: description,

        projectCategory: projectCategory,
        projectSubType: projectSubType,

        siteArea: siteArea,
        length: length,
        width: width,
        elevation: elevation,

        location: location,
        latitude: latitude,
        longitude: longitude,

        soilType: soilType,
        foundationType: foundationType,
        structureType: structureType,
        materialGrade: materialGrade,
        seismicZone: seismicZone,
        designCode: designCode,

        budget: budget,
        contractor: contractor,
        consultant: consultant,
        projectStatus: projectStatus,
        projectStage: projectStage,

        startDate: startDate,
        completionDate: completionDate,
      );

      projects.add(project);
      filteredProjects.add(project);

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

      projects.removeWhere((p) => p.id == projectId);
      filteredProjects.removeWhere((p) => p.id == projectId);

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
