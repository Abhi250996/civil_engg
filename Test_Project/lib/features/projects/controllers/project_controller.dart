import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';

class ProjectController extends GetxController {
  final ProjectRepository _repository = ProjectRepository();

  final RxBool isLoading = false.obs;
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<ProjectModel> filteredProjects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      final result = await _repository.getProjects();
      projects.assignAll(result);
      filteredProjects.assignAll(result);
    } catch (e) {
      _showSnackbar("Error", "Failed to load projects", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProjects() async {
    await loadProjects();
  }

  void searchProjects(String query) {
    if (query.isEmpty) {
      filteredProjects.assignAll(projects);
      return;
    }
    filteredProjects.assignAll(
      projects.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
          (p.projectCategory ?? "").toLowerCase().contains(query.toLowerCase())),
    );
  }

  /// ==========================================
  /// CREATE PROJECT (Synced with New Entry Form)
  /// ==========================================
  Future<void> createProject({
    required String name,
    required String description,
    String? projectCategory,
    String? projectSubType,    // Added
    String? location,
    double? length,
    double? width,
    double? siteArea,         // Added
    double? budget,
    double? elevation,        // Added
    double? latitude,         // Added
    double? longitude,        // Added
    String? soilType,
    String? foundationType,
    String? structureType,
    String? materialGrade,    // Added
    String? contractor,       // Added
    String? consultant,       // Added
    String? projectStatus,    // Added
    String? projectStage,     // Added
    DateTime? startDate,
    DateTime? completionDate, // Added
  }) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      // Repository ko saara data pass kar rahe hain
      final project = await _repository.createProject(
        name: name,
        description: description,
        projectCategory: projectCategory,
        projectSubType: projectSubType,
        location: location,
        length: length,
        width: width,
        siteArea: siteArea,
        budget: budget,
        elevation: elevation,
        latitude: latitude,
        longitude: longitude,
        soilType: soilType,
        foundationType: foundationType,
        structureType: structureType,
        materialGrade: materialGrade,
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
      _showSnackbar("Success", "Project '$name' saved with full details", isError: false);
    } catch (e) {
      _showSnackbar("Error", "Could not save all project fields", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _repository.deleteProject(projectId);
      projects.removeWhere((p) => p.id == projectId);
      filteredProjects.removeWhere((p) => p.id == projectId);
      _showSnackbar("Deleted", "Project removed successfully", isError: false);
    } catch (e) {
      _showSnackbar("Error", "Failed to delete project", isError: true);
    }
  }

  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      icon: Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void openProject(ProjectModel project) {
    Get.toNamed(RouteConstants.projectDetail, arguments: project);
  }
}