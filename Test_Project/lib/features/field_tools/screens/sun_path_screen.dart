import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class SunPathScreen extends StatefulWidget {
  const SunPathScreen({super.key});

  @override
  State<SunPathScreen> createState() => _SunPathScreenState();
}

class _SunPathScreenState extends State<SunPathScreen> {
  /// THEME
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

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
    /// placeholder values
    setState(() {
      sunrise = "06:12 AM";
      sunset = "06:45 PM";
      azimuth = "135° (SE)";
      elevation = "52°";
    });
  }

  Widget inputField(
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
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget resultCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sunDiagram() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.yellow.shade50,
        border: Border.all(color: Colors.orange),
      ),
      child: const Center(
        child: Text(
          "Solar Path Diagram\n(Visualization Placeholder)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget orientationGuide() {
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
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    Widget content = Column(
      children: [
        /// LAT + LNG
        Row(
          children: [
            Expanded(
              child: inputField("Latitude", latitudeController, "28.6139"),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: inputField("Longitude", longitudeController, "77.2090"),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// DATE
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
              style: ElevatedButton.styleFrom(backgroundColor: accentBlue),
              child: const Text(
                "Select Date",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// CALCULATE
        SizedBox(
          width: 300,
          child: ElevatedButton(
            onPressed: calculateSunPosition,
            style: ElevatedButton.styleFrom(backgroundColor: accentBlue),
            child: const Text(
              "Calculate Sun Position",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 25),

        /// RESULTS
        Row(
          children: [
            resultCard("Sunrise", sunrise),
            resultCard("Sunset", sunset),
          ],
        ),

        Row(
          children: [
            resultCard("Azimuth", azimuth),
            resultCard("Elevation", elevation),
          ],
        ),

        const SizedBox(height: 20),

        /// DIAGRAM + GUIDE
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: sunDiagram()),
            const SizedBox(width: 10),
            Expanded(child: orientationGuide()),
          ],
        ),
      ],
    );

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryBlue,
        title: const Text(
          "SUN PATH ANALYZER",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        /// WEB / DESKTOP → NO SCROLL
        child: kIsWeb
            ? content
            /// MOBILE → SCROLL
            : SingleChildScrollView(child: content),
      ),
    );
  }
}
