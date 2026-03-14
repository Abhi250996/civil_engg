import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/field_tools_controller.dart';

class SiteDiaryScreen extends StatefulWidget {
  const SiteDiaryScreen({super.key});

  @override
  State<SiteDiaryScreen> createState() => _SiteDiaryScreenState();
}

class _SiteDiaryScreenState extends State<SiteDiaryScreen> {
  final controller = Get.find<FieldToolsController>();

  DateTime selectedDate = DateTime.now();

  final weatherOptions = ["Sunny", "Cloudy", "Rainy", "Storm"];

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget inputField(
    String label,
    TextEditingController controller, {
    int lines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text("Site Diary")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// DATE
            Row(
              children: [
                Expanded(child: Text("Date: $formattedDate")),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Select Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// PROJECT
            inputField("Project Name", controller.projectController),

            const SizedBox(height: 20),

            /// ENGINEER
            inputField("Engineer / Supervisor", controller.engineerController),

            const SizedBox(height: 20),

            /// WEATHER
            Obx(
              () => DropdownButtonFormField(
                value: controller.weather.value,
                decoration: const InputDecoration(
                  labelText: "Weather",
                  border: OutlineInputBorder(),
                ),
                items: weatherOptions
                    .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                    .toList(),
                onChanged: (value) {
                  controller.weather.value = value!;
                },
              ),
            ),

            const SizedBox(height: 20),

            /// WORKERS
            inputField("Number of Workers", controller.labourController),

            const SizedBox(height: 20),

            /// WORK DONE
            inputField("Work Done Today", controller.workController, lines: 3),

            const SizedBox(height: 20),

            /// ISSUES
            inputField(
              "Issues / Delays",
              controller.issuesController,
              lines: 3,
            ),

            const SizedBox(height: 20),

            /// NOTES
            inputField(
              "Additional Notes",
              controller.notesController,
              lines: 3,
            ),

            const SizedBox(height: 20),

            /// PHOTO
            Row(
              children: [
                ElevatedButton(
                  onPressed: controller.openCamera,
                  child: const Text("Capture Photo"),
                ),
                const SizedBox(width: 20),

                Obx(() {
                  final image = controller.capturedImage.value;
                  if (image == null) return const SizedBox();

                  return SizedBox(height: 60, child: Image.file(image));
                }),
              ],
            ),

            const SizedBox(height: 20),

            /// LOCATION
            Row(
              children: [
                ElevatedButton(
                  onPressed: controller.captureLocation,
                  child: const Text("Capture Location"),
                ),
                const SizedBox(width: 20),

                Expanded(child: Obx(() => Text(controller.location.value))),
              ],
            ),

            const SizedBox(height: 30),

            /// SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveSiteDiaryEntry,
                child: const Text("Save Site Diary Entry"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
