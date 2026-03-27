import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';

class SunPathScreen extends StatefulWidget {
  const SunPathScreen({super.key});

  @override
  State<SunPathScreen> createState() => _SunPathScreenState();
}

class _SunPathScreenState extends State<SunPathScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

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

    if (date != null) setState(() => selectedDate = date);
  }

  void calculateSunPosition() {
    setState(() {
      sunrise = "06:12 AM";
      sunset = "06:45 PM";
      azimuth = "135° (SE)";
      elevation = "52°";
    });
  }

  /// ================= UI =================

  Widget field(String label, TextEditingController c, String hint) {
    return TextField(
      controller: c,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
      child: const Center(child: Text("Solar Path Diagram")),
    );
  }

  Widget guide() {
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
            "Orientation Guide",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("• South → more sunlight"),
          Text("• East → morning light"),
          Text("• North → minimal sun"),
          Text("• West → heat"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return AppScaffold(
      title: "Sun Path Analyzer",
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
                    "SUN PATH ANALYZER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

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
                            /// INPUT
                            Row(
                              children: [
                                Expanded(
                                  child: field(
                                    "Latitude",
                                    latitudeController,
                                    "28.61",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: field(
                                    "Longitude",
                                    longitudeController,
                                    "77.20",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// DATE
                            Row(
                              children: [
                                Expanded(child: Text("Date: $formattedDate")),
                                ElevatedButton(
                                  onPressed: pickDate,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentBlue,
                                  ),
                                  child: const Text(
                                    "Select Date",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// BUTTON
                            SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                onPressed: calculateSunPosition,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentBlue,
                                ),
                                child: const Text(
                                  "CALCULATE",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// RESULTS
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                resultCard("Sunrise", sunrise),
                                resultCard("Sunset", sunset),
                                resultCard("Azimuth", azimuth),
                                resultCard("Elevation", elevation),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// BOTTOM
                            isDesktop
                                ? Row(
                                    children: [
                                      Expanded(child: sunDiagram()),
                                      const SizedBox(width: 12),
                                      Expanded(child: guide()),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      sunDiagram(),
                                      const SizedBox(height: 12),
                                      guide(),
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
