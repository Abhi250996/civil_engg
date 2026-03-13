import 'package:get/get.dart';
import '../../../data/models/report_model.dart';
import '../../../data/repositories/report_repository.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ReportController extends GetxController {
  final ReportRepository _repository = ReportRepository();
  final RxString selectedFilePath = "".obs;

  /// =========================
  /// STATE
  /// =========================

  final RxBool isLoading = false.obs;

  final RxList<ReportModel> reports = <ReportModel>[].obs;

  final RxList<ReportModel> filteredReports = <ReportModel>[].obs;

  /// =========================
  /// LOAD REPORTS
  /// =========================

  Future<void> loadReports() async {
    try {
      isLoading.value = true;

      final result = await _repository.getReports();

      reports.assignAll(result);
      filteredReports.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load reports");
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// SEARCH REPORTS
  /// =========================

  void searchReports(String query) {
    if (query.isEmpty) {
      filteredReports.assignAll(reports);
      return;
    }

    filteredReports.assignAll(
      reports.where(
        (r) =>
            r.title.toLowerCase().contains(query.toLowerCase()) ||
            (r.reportType).toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

  /// =========================
  /// CREATE REPORT
  /// =========================

  Future<void> createReport({
    required String projectId,
    required String title,
    required String description,
    required String reportType,
    required String filePath,

    String? category,
    String? department,

    String? author,
    String? engineer,
    String? organization,

    String? status,
    String? approvedBy,

    int? version,
    String? revision,

    String? location,
    double? latitude,
    double? longitude,

    List<String>? tags,

    DateTime? reportDate,
    DateTime? approvedDate,

    String? fileFormat,
    double? fileSize,
  }) async {
    try {
      isLoading.value = true;

      final report = await _repository.createReport(
        projectId: projectId,
        title: title,
        description: description,
        reportType: reportType,
        filePath: filePath,

        category: category,
        department: department,

        author: author,
        engineer: engineer,
        organization: organization,

        status: status,
        approvedBy: approvedBy,

        version: version,
        revision: revision,

        location: location,
        latitude: latitude,
        longitude: longitude,

        tags: tags,

        reportDate: reportDate,
        approvedDate: approvedDate,

        fileFormat: fileFormat,
        fileSize: fileSize,
      );

      reports.add(report);
      filteredReports.add(report);

      Get.back();

      Get.snackbar("Success", "Report created successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to create report");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFile() async {
    try {
      /// WEB + DESKTOP
      if (kIsWeb ||
          Platform.isWindows ||
          Platform.isMacOS ||
          Platform.isLinux) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'doc',
            'docx',
            'xls',
            'xlsx',
            'png',
            'jpg',
          ],
        );

        if (result != null) {
          selectedFilePath.value = result.files.single.path ?? "";
        }
      }
      /// MOBILE
      else {
        final ImagePicker picker = ImagePicker();

        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          selectedFilePath.value = image.path;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to select file");
    }
  }

  /// =========================
  /// UPDATE REPORT
  /// =========================

  Future<void> updateReport({
    required String reportId,
    required Map<String, dynamic> data,
  }) async {
    try {
      isLoading.value = true;

      final updatedReport = await _repository.updateReport(
        reportId: reportId,
        data: data,
      );

      final index = reports.indexWhere((r) => r.id == reportId);

      if (index != -1) {
        reports[index] = updatedReport;
      }

      loadReports();

      Get.snackbar("Success", "Report updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update report");
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

      reports.removeWhere((r) => r.id == reportId);
      filteredReports.removeWhere((r) => r.id == reportId);

      Get.snackbar("Success", "Report deleted");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete report");
    }
  }

  /// =========================
  /// OPEN REPORT
  /// =========================
  void openReport(ReportModel report) async {
    try {
      final path = report.filePath.trim();
      print("Opening report: $path");

      if (path.isEmpty || path == "not needed") {
        Get.snackbar("Error", "Invalid report file");
        return;
      }

      /// WEB
      if (kIsWeb) {
        final uri = Uri.tryParse(path);

        if (uri == null) {
          Get.snackbar("Error", "Invalid URL");
          return;
        }

        if (!await launchUrl(uri)) {
          Get.snackbar("Error", "Could not open report");
        }

        return;
      }

      /// LOCAL FILE (Mobile / Desktop)
      if (!path.startsWith("http")) {
        final result = await OpenFilex.open(path);

        if (result.type != ResultType.done) {
          Get.snackbar("Error", result.message);
        }

        return;
      }

      /// CLOUD FILE (Firebase / Internet)
      final uri = Uri.parse(path);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not open report");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to open report");
    }
  }
}
