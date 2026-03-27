import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../controllers/report_controller.dart';
import '../widgets/report_card.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final controller = Get.find<ReportController>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  void initState() {
    super.initState();
    controller.loadReports();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      body: Container(
        /// 🔥 GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text(
                        "TECHNICAL REPORTS",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: () =>
                            Get.toNamed(RouteConstants.createReport),
                        icon: const Icon(Icons.add),
                        label: const Text("NEW REPORT"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryBlue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ================= MAIN CARD =================
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        children: [
                          /// SEARCH + FILTER
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: controller.searchReports,
                                  decoration: InputDecoration(
                                    hintText: "Search reports...",
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              IconButton(
                                icon: const Icon(Icons.filter_list),
                                onPressed: () {},
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// ================= LIST =================
                          Expanded(
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (controller.filteredReports.isEmpty) {
                                return _emptyState();
                              }

                              return RefreshIndicator(
                                onRefresh: controller.loadReports,
                                child: GridView.builder(
                                  itemCount: controller.filteredReports.length,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: isDesktop
                                            ? 350
                                            : 400,
                                        mainAxisExtent: 180,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  itemBuilder: (_, i) {
                                    final report =
                                        controller.filteredReports[i];

                                    return ReportCard(
                                      report: report,
                                      onOpen: () =>
                                          controller.openReport(report),
                                      onDelete: () =>
                                          controller.deleteReport(report.id),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 70,
            color: primaryBlue.withOpacity(0.2),
          ),
          const SizedBox(height: 10),
          const Text(
            "No Reports Found",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Generate your first report to get started",
            style: TextStyle(color: primaryBlue.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
