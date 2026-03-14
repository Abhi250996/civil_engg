import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_tools_controller.dart';

class SiteDiaryListScreen extends StatelessWidget {
  const SiteDiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FieldToolsController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Site Diary")),

      body: Obx(() {
        if (controller.diaryEntries.isEmpty) {
          return const Center(child: Text("No entries saved"));
        }

        return ListView.builder(
          itemCount: controller.diaryEntries.length,

          itemBuilder: (context, index) {
            final entry = controller.diaryEntries[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: ListTile(
                title: Text(entry["project"] ?? ""),

                subtitle: Text(entry["date"]),

                trailing: const Icon(Icons.arrow_forward),

                onTap: () {
                  _showEntryDialog(entry);
                },
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
              Text("Engineer: ${entry["engineer"]}"),
              Text("Weather: ${entry["weather"]}"),
              Text("Workers: ${entry["workers"]}"),

              const SizedBox(height: 10),

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
