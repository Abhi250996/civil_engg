import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/report_model.dart';
import '../../../data/repositories/report_repository.dart';

class ReportController extends GetxController {
  final ReportRepository _repository = ReportRepository();

  /// =========================
  /// STATE
  /// =========================

  final RxBool isLoading = false.obs;

  final RxList<ReportModel> reports = <ReportModel>[].obs;

  /// =========================
  /// LOAD REPORTS
  /// =========================

  Future<void> loadReports() async {
    try {
      isLoading.value = true;

      final result = await _repository.getReports();

      reports.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load reports");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// CREATE REPORT
  /// =========================

  Future<void> createReport({
    required String title,
    required String description,
    required String filePath,
  }) async {
    try {
      isLoading.value = true;

      final report = await _repository.createReport(
        projectId: "1", // placeholder project id
        title: title,
        description: description,
        filePath: filePath,
      );

      reports.add(report);

      Get.back();

      Get.snackbar("Success", "Report created successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to create report");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// DELETE REPORT
  /// =========================

  Future<void> deleteReport(String reportId) async {
    try {
      await _repository.deleteReport(reportId);

      reports.removeWhere((report) => report.id == reportId);

      Get.snackbar("Success", "Report deleted");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete report");
    }
  }

  /// =========================
  /// OPEN REPORT
  /// =========================

  void openReport(ReportModel report) {
    Get.snackbar("Open Report", "Opening: ${report.title}");

    /// Later you can add:
    /// - PDF viewer
    /// - document viewer
    /// - CAD viewer
  }
}
