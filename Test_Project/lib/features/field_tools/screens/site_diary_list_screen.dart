import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_tools_controller.dart';

class SiteDiaryListScreen extends StatelessWidget {
  const SiteDiaryListScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color bgColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FieldToolsController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          "SITE DIARY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (controller.diaryEntries.isEmpty) {
          return const Center(child: Text("No entries saved"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.diaryEntries.length,

          itemBuilder: (context, index) {
            final entry = controller.diaryEntries[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),

              child: InkWell(
                onTap: () => _showEntryDialog(entry),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PROJECT + DATE
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry["project"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        Text(
                          entry["date"],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// ENGINEER + WORKERS
                    Row(
                      children: [
                        Expanded(child: Text("Engineer: ${entry["engineer"]}")),
                        Expanded(child: Text("Workers: ${entry["workers"]}")),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// WEATHER + LOCATION
                    Row(
                      children: [
                        Expanded(child: Text("Weather: ${entry["weather"]}")),
                        Expanded(child: Text("Location: ${entry["location"]}")),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showEntryDialog(Map entry) {
    Get.dialog(
      AlertDialog(
        title: Text(entry["project"]),

        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ENGINEER + DATE
              Row(
                children: [
                  Expanded(child: Text("Engineer: ${entry["engineer"]}")),
                  Expanded(child: Text("Date: ${entry["date"]}")),
                ],
              ),

              const SizedBox(height: 8),

              /// WEATHER + WORKERS
              Row(
                children: [
                  Expanded(child: Text("Weather: ${entry["weather"]}")),
                  Expanded(child: Text("Workers: ${entry["workers"]}")),
                ],
              ),

              const SizedBox(height: 12),

              Text("Work Done:\n${entry["work"]}"),

              const SizedBox(height: 10),

              Text("Issues:\n${entry["issues"]}"),

              const SizedBox(height: 10),

              Text("Notes:\n${entry["notes"]}"),

              const SizedBox(height: 10),

              Text("Location:\n${entry["location"]}"),

              const SizedBox(height: 10),

              if (entry["image"] != null)
                Image.file(entry["image"], height: 120),
            ],
          ),
        ),

        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }
}
