import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SunPathScreen extends StatefulWidget {
  const SunPathScreen({super.key});

  @override
  State<SunPathScreen> createState() => _SunPathScreenState();
}

class _SunPathScreenState extends State<SunPathScreen> {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String sunrise = "--:--";
  String sunset = "--:--";
  String azimuth = "--";
  String elevation = "--";

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void calculateSunPosition() {
    /// NOTE:
    /// Placeholder values.
    /// Later you can connect solar calculation formulas.
    setState(() {
      sunrise = "06:12 AM";
      sunset = "06:45 PM";
      azimuth = "135° (SE)";
      elevation = "52°";
    });
  }

  Widget buildInputField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildResultCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget buildSunDiagram() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.yellow.shade50,
        border: Border.all(color: Colors.orange),
      ),
      child: const Center(
        child: Text(
          "Solar Path Diagram\n(Visual Orientation Placeholder)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget buildOrientationGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Building Orientation Guide",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text("• South facing buildings receive more sunlight."),
          Text("• East orientation is ideal for morning light."),
          Text("• North side gets minimal direct sunlight."),
          Text("• West side gets strong afternoon heat."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text("Sun Path Analyzer")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// LOCATION INPUT
            buildInputField("Latitude", latitudeController, "Example: 28.6139"),
            const SizedBox(height: 15),
            buildInputField(
              "Longitude",
              longitudeController,
              "Example: 77.2090",
            ),

            const SizedBox(height: 20),

            /// DATE PICKER
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: $formattedDate",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Select Date"),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// CALCULATE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateSunPosition,
                child: const Text("Calculate Sun Position"),
              ),
            ),

            const SizedBox(height: 30),

            /// RESULT CARDS
            Row(
              children: [
                buildResultCard("Sunrise", sunrise),
                buildResultCard("Sunset", sunset),
              ],
            ),
            Row(
              children: [
                buildResultCard("Azimuth", azimuth),
                buildResultCard("Elevation", elevation),
              ],
            ),

            const SizedBox(height: 30),

            /// SUN DIAGRAM
            buildSunDiagram(),

            const SizedBox(height: 30),

            /// ORIENTATION GUIDE
            buildOrientationGuide(),
          ],
        ),
      ),
    );
  }
}
