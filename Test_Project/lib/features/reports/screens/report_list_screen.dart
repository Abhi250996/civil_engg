import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/report_model.dart';
import '../controllers/report_controller.dart';
import '../widgets/report_card.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find();

    controller.loadReports();

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteConstants.createReport);
        },
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reports.isEmpty) {
          return const Center(child: Text("No reports available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: controller.reports.length,

          itemBuilder: (context, index) {
            ReportModel report = controller.reports[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),

              child: ReportCard(
                report: report,
                onOpen: () {
                  controller.openReport(report);
                },
                onDelete: () {
                  controller.deleteReport(report.id);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
