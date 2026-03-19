import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_project/core/utils/app_scaffold.dart';
import 'site_diary_list_screen.dart';

class SiteDiaryScreen extends StatefulWidget {
  const SiteDiaryScreen({super.key});

  @override
  State<SiteDiaryScreen> createState() => _SiteDiaryScreenState();
}

class _SiteDiaryScreenState extends State<SiteDiaryScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  final projectController = TextEditingController();
  final engineerController = TextEditingController();
  final labourController = TextEditingController();
  final workController = TextEditingController();
  final issuesController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedWeather = "Sunny";

  File? imageFile;
  String location = "Location not captured";

  final weatherOptions = ["Sunny", "Cloudy", "Rainy", "Storm"];

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> capturePhoto() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) setState(() => imageFile = File(photo.path));
  }

  Future<void> getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enable GPS")));
      return;
    }

    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      location =
          "Lat: ${pos.latitude.toStringAsFixed(5)}, Lng: ${pos.longitude.toStringAsFixed(5)}";
    });
  }

  void saveEntry() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Entry saved (Firebase ready)")),
    );
  }

  Widget field(String label, TextEditingController c, {int lines = 1}) {
    return TextField(
      controller: c,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget btn(String text, VoidCallback onTap) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return AppScaffold(
      title: "Site Diary",
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
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// FORM
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Column(
                          children: [
                            /// DATE
                            Row(
                              children: [
                                Expanded(child: Text("Date: $formattedDate")),
                                btn("Select Date", pickDate),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// PROJECT + ENGINEER
                            Row(
                              children: [
                                Expanded(
                                  child: field("Project", projectController),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: field("Engineer", engineerController),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// WEATHER + WORKERS
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: selectedWeather,
                                    items: weatherOptions
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedWeather = v!),
                                    decoration: const InputDecoration(
                                      labelText: "Weather",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: field("Workers", labourController),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// WORK + ISSUES
                            Row(
                              children: [
                                Expanded(
                                  child: field(
                                    "Work Done",
                                    workController,
                                    lines: 4,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: field(
                                    "Issues",
                                    issuesController,
                                    lines: 4,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            field("Notes", notesController, lines: 2),

                            const SizedBox(height: 16),

                            /// PHOTO
                            Row(
                              children: [
                                btn("Capture Photo", capturePhoto),
                                const SizedBox(width: 10),
                                if (imageFile != null)
                                  Image.file(imageFile!, height: 50),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// LOCATION
                            Row(
                              children: [
                                btn("Capture Location", getLocation),
                                const SizedBox(width: 10),
                                Expanded(child: Text(location)),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// ACTIONS
                            Row(
                              children: [
                                Expanded(
                                  child: btn("View Entries", () {
                                    Get.to(() => const SiteDiaryListScreen());
                                  }),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: btn("Save Entry", saveEntry)),
                              ],
                            ),
                          ],
                        ),
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
}
