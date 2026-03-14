import 'dart:math';
import 'package:flutter/material.dart';

class SlopeCalcScreen extends StatefulWidget {
  const SlopeCalcScreen({super.key});

  @override
  State<SlopeCalcScreen> createState() => _SlopeCalcScreenState();
}

class _SlopeCalcScreenState extends State<SlopeCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  final riseController = TextEditingController();
  final runController = TextEditingController();

  String unit = "Meter";

  double slopePercent = 0;
  double slopeAngle = 0;
  double slopeRatio = 0;

  final units = ["Meter", "Feet", "Inch", "Centimeter"];

  double convertToMeters(double value) {
    switch (unit) {
      case "Feet":
        return value * 0.3048;
      case "Inch":
        return value * 0.0254;
      case "Centimeter":
        return value / 100;
      default:
        return value;
    }
  }

  void calculate() {
    double rise = convertToMeters(double.tryParse(riseController.text) ?? 0);
    double run = convertToMeters(double.tryParse(runController.text) ?? 0);

    if (run == 0) return;

    setState(() {
      /// SLOPE %
      slopePercent = (rise / run) * 100;

      /// ANGLE
      slopeAngle = atan(rise / run) * 180 / pi;

      /// RATIO
      slopeRatio = run / rise;
    });
  }

  Widget field(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "$label ($unit)",
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
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slopeGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Slope Engineering Guide",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text("• Road slope usually 2% – 6%"),
          Text("• Roof drainage slope: 1:40"),
          Text("• Ramp slope standard: 1:12"),
          Text("• Railway gradient approx 1:100"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: primaryBlue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "SLOPE CALCULATOR",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// UNIT
            DropdownButtonFormField(
              value: unit,
              decoration: const InputDecoration(
                labelText: "Measurement Unit",
                border: OutlineInputBorder(),
              ),
              items: units
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  unit = v!;
                });
              },
            ),

            const SizedBox(height: 15),

            /// INPUTS
            Row(
              children: [
                Expanded(child: field("Rise", riseController)),
                const SizedBox(width: 10),
                Expanded(child: field("Run", runController)),
              ],
            ),

            const SizedBox(height: 20),

            /// BUTTON
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(backgroundColor: accentBlue),
                child: const Text(
                  "CALCULATE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// RESULT ROW 1
            Row(
              children: [
                resultCard("Slope %", "${slopePercent.toStringAsFixed(2)} %"),
                resultCard("Angle", "${slopeAngle.toStringAsFixed(2)} °"),
              ],
            ),

            /// RESULT ROW 2
            Row(
              children: [
                resultCard("Ratio", "1 : ${slopeRatio.toStringAsFixed(2)}"),
                resultCard("Gradient", "Rise/Run"),
              ],
            ),

            const SizedBox(height: 20),

            /// GUIDE
            slopeGuide(),
          ],
        ),
      ),
    );
  }
}
