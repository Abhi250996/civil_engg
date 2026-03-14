import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_project/features/field_tools/screens/site_diary_list_screen.dart';

class SiteDiaryScreen extends StatefulWidget {
  const SiteDiaryScreen({super.key});

  @override
  State<SiteDiaryScreen> createState() => _SiteDiaryScreenState();
}

class _SiteDiaryScreenState extends State<SiteDiaryScreen> {
  final TextEditingController projectController = TextEditingController();
  final TextEditingController engineerController = TextEditingController();
  final TextEditingController labourController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController issuesController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedWeather = "Sunny";

  File? imageFile;
  String location = "Location not captured";

  final weatherOptions = ["Sunny", "Cloudy", "Rainy", "Storm"];

  /// DATE PICKER
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

  /// CAMERA
  Future<void> capturePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  /// GPS LOCATION
  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enable GPS")));
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      location =
          "Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}";
    });
  }

  /// SAVE ENTRY (READY FOR FIREBASE)
  void saveEntry() {
    final diaryEntry = {
      "date": DateFormat("yyyy-MM-dd").format(selectedDate),
      "project": projectController.text,
      "engineer": engineerController.text,
      "weather": selectedWeather,
      "workers": labourController.text,
      "work_done": workController.text,
      "issues": issuesController.text,
      "notes": notesController.text,
      "location": location,
      "photo": imageFile?.path,
    };

    debugPrint("Diary Entry Data: $diaryEntry");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Entry saved locally (Firebase ready)")),
    );
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
            inputField("Project Name", projectController),

            const SizedBox(height: 20),

            /// ENGINEER
            inputField("Engineer / Supervisor", engineerController),

            const SizedBox(height: 20),

            /// WEATHER
            DropdownButtonFormField(
              value: selectedWeather,
              decoration: const InputDecoration(
                labelText: "Weather",
                border: OutlineInputBorder(),
              ),
              items: weatherOptions
                  .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedWeather = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// WORKERS
            inputField("Number of Workers", labourController),

            const SizedBox(height: 20),

            /// WORK DONE
            inputField("Work Done Today", workController, lines: 3),

            const SizedBox(height: 20),

            /// ISSUES
            inputField("Issues / Delays", issuesController, lines: 3),

            const SizedBox(height: 20),

            /// NOTES
            inputField("Additional Notes", notesController, lines: 3),

            const SizedBox(height: 20),

            /// PHOTO
            Row(
              children: [
                ElevatedButton(
                  onPressed: capturePhoto,
                  child: const Text("Capture Photo"),
                ),
                const SizedBox(width: 20),
                if (imageFile != null)
                  SizedBox(height: 60, child: Image.file(imageFile!)),
              ],
            ),

            const SizedBox(height: 20),

            /// LOCATION
            Row(
              children: [
                ElevatedButton(
                  onPressed: getLocation,
                  child: const Text("Capture Location"),
                ),
                const SizedBox(width: 20),
                Expanded(child: Text(location)),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => const SiteDiaryListScreen());
              },
              icon: const Icon(Icons.history),
              label: const Text("View Saved Entries"),
            ),

            /// SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveEntry,
                child: const Text("Save Site Diary Entry"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
