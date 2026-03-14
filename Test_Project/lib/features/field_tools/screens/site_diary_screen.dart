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
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

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

  Future<void> capturePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

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
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    Widget formContent = Column(
      children: [
        /// DATE
        Row(
          children: [
            Expanded(
              child: Text(
                "Date: $formattedDate",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: pickDate,
              style: ElevatedButton.styleFrom(backgroundColor: accentBlue),
              child: const Text(
                "Select Date",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// PROJECT + ENGINEER
        Row(
          children: [
            Expanded(child: inputField("Project Name", projectController)),
            const SizedBox(width: 10),
            Expanded(
              child: inputField("Engineer / Supervisor", engineerController),
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
            ),
            const SizedBox(width: 10),
            Expanded(child: inputField("Workers", labourController)),
          ],
        ),

        const SizedBox(height: 16),

        /// WORK + ISSUES
        Row(
          children: [
            Expanded(
              child: inputField("Work Done Today", workController, lines: 4),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: inputField("Issues / Delays", issuesController, lines: 4),
            ),
          ],
        ),

        const SizedBox(height: 16),

        inputField("Additional Notes", notesController, lines: 2),

        const SizedBox(height: 16),

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

        const SizedBox(height: 16),

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

        const SizedBox(height: 20),

        /// BUTTONS
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const SiteDiaryListScreen());
                },
                icon: const Icon(Icons.history),
                label: const Text("View Entries"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: saveEntry,
                style: ElevatedButton.styleFrom(backgroundColor: accentBlue),
                child: const Text(
                  "Save Entry",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "SITE DIARY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GetPlatform.isWeb
            ? Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: formContent,
              )
            /// MOBILE SCROLL VERSION
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: formContent,
                ),
              ),
      ),
    );
  }
}
