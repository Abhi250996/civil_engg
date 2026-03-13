import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/report_model.dart';
import '../controllers/report_controller.dart';
import '../widgets/report_card.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final ReportController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.loadReports();
  }

  int getCrossAxisCount(double width) {
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 700) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(RouteConstants.createReport);
        },
        icon: const Icon(Icons.add),
        label: const Text("New Report"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// SEARCH
            TextField(
              decoration: const InputDecoration(
                hintText: "Search reports...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: controller.searchReports,
            ),

            const SizedBox(height: 16),

            /// LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredReports.isEmpty) {
                  return const Center(
                    child: Text(
                      "No reports available",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadReports,

                  child: GridView.builder(
                    itemCount: controller.filteredReports.length,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(width),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                    ),

                    itemBuilder: (context, index) {
                      ReportModel report = controller.filteredReports[index];

                      return ReportCard(
                        report: report,

                        onOpen: () {
                          controller.openReport(report);
                        },

                        onDelete: () {
                          controller.deleteReport(report.id);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
