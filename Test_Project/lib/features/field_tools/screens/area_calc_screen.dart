import 'dart:math';
import 'package:flutter/material.dart';

class AreaCalcScreen extends StatefulWidget {
  const AreaCalcScreen({super.key});

  @override
  State<AreaCalcScreen> createState() => _AreaCalcScreenState();
}

class _AreaCalcScreenState extends State<AreaCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  String areaType = "Rectangle";
  String unit = "Meter";

  final length = TextEditingController();
  final width = TextEditingController();
  final radius = TextEditingController();
  final base = TextEditingController();
  final height = TextEditingController();
  final sideA = TextEditingController();
  final sideB = TextEditingController();

  double result = 0;

  final units = ["Meter", "Feet", "Yard", "Centimeter"];

  double convertToMeters(double value) {
    switch (unit) {
      case "Feet":
        return value * 0.3048;
      case "Yard":
        return value * 0.9144;
      case "Centimeter":
        return value / 100;
      default:
        return value;
    }
  }

  void calculate() {
    switch (areaType) {
      /// RECTANGLE
      case "Rectangle":
        double l = convertToMeters(double.tryParse(length.text) ?? 0);
        double w = convertToMeters(double.tryParse(width.text) ?? 0);
        result = l * w;
        break;

      /// TRIANGLE
      case "Triangle":
        double b = convertToMeters(double.tryParse(base.text) ?? 0);
        double h = convertToMeters(double.tryParse(height.text) ?? 0);
        result = 0.5 * b * h;
        break;

      /// CIRCLE
      case "Circle":
        double r = convertToMeters(double.tryParse(radius.text) ?? 0);
        result = pi * r * r;
        break;

      /// TRAPEZOID
      case "Trapezoid":
        double a = convertToMeters(double.tryParse(sideA.text) ?? 0);
        double b = convertToMeters(double.tryParse(sideB.text) ?? 0);
        double h = convertToMeters(double.tryParse(height.text) ?? 0);
        result = ((a + b) / 2) * h;
        break;
    }

    setState(() {});
  }

  Widget field(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "$label ($unit)",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget buildInputs() {
    switch (areaType) {
      case "Rectangle":
        return Row(
          children: [
            Expanded(child: field(length, "Length")),
            const SizedBox(width: 10),
            Expanded(child: field(width, "Width")),
          ],
        );

      case "Triangle":
        return Row(
          children: [
            Expanded(child: field(base, "Base")),
            const SizedBox(width: 10),
            Expanded(child: field(height, "Height")),
          ],
        );

      case "Circle":
        return field(radius, "Radius");

      case "Trapezoid":
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: field(sideA, "Side A")),
                const SizedBox(width: 10),
                Expanded(child: field(sideB, "Side B")),
              ],
            ),
            const SizedBox(height: 10),
            field(height, "Height"),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryBlue,
        title: const Text(
          "AREA CALCULATOR",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// AREA TYPE
            DropdownButtonFormField(
              value: areaType,
              decoration: const InputDecoration(
                labelText: "Area Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Rectangle", child: Text("Rectangle")),
                DropdownMenuItem(value: "Triangle", child: Text("Triangle")),
                DropdownMenuItem(value: "Circle", child: Text("Circle")),
                DropdownMenuItem(value: "Trapezoid", child: Text("Trapezoid")),
              ],
              onChanged: (v) {
                setState(() {
                  areaType = v!;
                });
              },
            ),

            const SizedBox(height: 12),

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

            const SizedBox(height: 20),

            /// INPUTS
            buildInputs(),

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

            /// RESULT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "RESULT AREA",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.toStringAsFixed(3),
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Square Meters",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
