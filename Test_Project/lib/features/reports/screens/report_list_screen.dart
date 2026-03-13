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

  // Theme Tokens
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    controller.loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "TECHNICAL REPORTS",
          style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 2
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: primaryBlue),
            onPressed: () { /* Add filter logic */ },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(RouteConstants.createReport),
        backgroundColor: primaryBlue,
        icon: const Icon(Icons.post_add_rounded, color: Colors.white),
        label: const Text("GENERATE REPORT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildSearchSection(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: accentBlue));
                  }

                  if (controller.filteredReports.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: controller.loadReports,
                    color: accentBlue,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.filteredReports.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 380, // Card width desktop par lock
                        mainAxisExtent: 180,     // Card height lock
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        ReportModel report = controller.filteredReports[index];
                        return ReportCard(
                          report: report,
                          onOpen: () => controller.openReport(report),
                          onDelete: () => controller.deleteReport(report.id),
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
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: TextField(
        onChanged: controller.searchReports,
        decoration: InputDecoration(
          hintText: "Search by title, author, or document type...",
          hintStyle: TextStyle(color: primaryBlue.withOpacity(0.3), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: accentBlue),
          filled: true,
          fillColor: bgColor,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentBlue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 80, color: primaryBlue.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            "No Reports Found",
            style: TextStyle(color: primaryBlue.withOpacity(0.4), fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "All generated project reports will appear here.",
            style: TextStyle(color: primaryBlue.withOpacity(0.3), fontSize: 13),
          ),
        ],
      ),
    );
  }
}