import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';
import '../controllers/field_tools_controller.dart';

class SiteDiaryListScreen extends StatelessWidget {
  const SiteDiaryListScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FieldToolsController>();

    return AppScaffold(
      title: "Site Diaries",
      showBack: true,
      child: Container(
        /// 🔥 GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// HEADER
                  const Text(
                    "SITE DIARY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MAIN CARD
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Obx(() {
                        if (controller.diaryEntries.isEmpty) {
                          return const Center(child: Text("No entries saved"));
                        }

                        return ListView.separated(
                          itemCount: controller.diaryEntries.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 20),

                          itemBuilder: (context, index) {
                            final entry = controller.diaryEntries[index];

                            return InkWell(
                              onTap: () => _showEntryDialog(entry),

                              child: Row(
                                children: [
                                  /// PROJECT
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      entry["project"] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  /// ENGINEER
                                  Expanded(
                                    child: Text(entry["engineer"] ?? ""),
                                  ),

                                  /// WORKERS
                                  Expanded(child: Text("${entry["workers"]}")),

                                  /// WEATHER
                                  Expanded(child: Text(entry["weather"] ?? "")),

                                  /// DATE
                                  Expanded(
                                    child: Text(
                                      entry["date"],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
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

  /// ================= DIALOG =================

  void _showEntryDialog(Map entry) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry["project"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text("Engineer: ${entry["engineer"]}"),
                Text("Date: ${entry["date"]}"),
                Text("Weather: ${entry["weather"]}"),
                Text("Workers: ${entry["workers"]}"),

                const SizedBox(height: 12),

                Text("Work:\n${entry["work"]}"),
                const SizedBox(height: 10),

                Text("Issues:\n${entry["issues"]}"),
                const SizedBox(height: 10),

                Text("Notes:\n${entry["notes"]}"),

                const SizedBox(height: 10),

                Text("Location:\n${entry["location"]}"),

                if (entry["image"] != null) ...[
                  const SizedBox(height: 10),
                  Image.file(entry["image"], height: 120),
                ],

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
