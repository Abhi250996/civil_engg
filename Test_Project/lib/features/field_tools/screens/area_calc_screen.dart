import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_project/core/utils/app_scaffold.dart';

class AreaCalcScreen extends StatefulWidget {
  const AreaCalcScreen({super.key});

  @override
  State<AreaCalcScreen> createState() => _AreaCalcScreenState();
}

class _AreaCalcScreenState extends State<AreaCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  String areaType = "Rectangle";
  String unit = "Meter";

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  final TextEditingController baseController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController sideAController = TextEditingController();
  final TextEditingController sideBController = TextEditingController();

  double result = 0;

  final units = ["Meter", "Feet", "Yard", "Centimeter"];

  /// ================= LOGIC =================

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
    double res = 0;

    switch (areaType) {
      case "Rectangle":
        final l = convertToMeters(double.tryParse(lengthController.text) ?? 0);
        final w = convertToMeters(double.tryParse(widthController.text) ?? 0);
        res = l * w;
        break;

      case "Triangle":
        final b = convertToMeters(double.tryParse(baseController.text) ?? 0);
        final h = convertToMeters(double.tryParse(heightController.text) ?? 0);
        res = 0.5 * b * h;
        break;

      case "Circle":
        final r = convertToMeters(double.tryParse(radiusController.text) ?? 0);
        res = pi * r * r;
        break;

      case "Trapezoid":
        final a = convertToMeters(double.tryParse(sideAController.text) ?? 0);
        final b = convertToMeters(double.tryParse(sideBController.text) ?? 0);
        final h = convertToMeters(double.tryParse(heightController.text) ?? 0);
        res = ((a + b) / 2) * h;
        break;
    }

    setState(() => result = res);
  }

  /// ================= UI =================

  bool isDesktop(double width) => width > 800;

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

  Widget buildInputs(double width) {
    final desktop = isDesktop(width);

    switch (areaType) {
      case "Rectangle":
        return desktop
            ? Row(
                children: [
                  Expanded(child: field(lengthController, "Length")),
                  const SizedBox(width: 12),
                  Expanded(child: field(widthController, "Width")),
                ],
              )
            : Column(
                children: [
                  field(lengthController, "Length"),
                  const SizedBox(height: 12),
                  field(widthController, "Width"),
                ],
              );

      case "Triangle":
        return desktop
            ? Row(
                children: [
                  Expanded(child: field(baseController, "Base")),
                  const SizedBox(width: 12),
                  Expanded(child: field(heightController, "Height")),
                ],
              )
            : Column(
                children: [
                  field(baseController, "Base"),
                  const SizedBox(height: 12),
                  field(heightController, "Height"),
                ],
              );

      case "Circle":
        return field(radiusController, "Radius");

      case "Trapezoid":
        return Column(
          children: [
            desktop
                ? Row(
                    children: [
                      Expanded(child: field(sideAController, "Side A")),
                      const SizedBox(width: 12),
                      Expanded(child: field(sideBController, "Side B")),
                    ],
                  )
                : Column(
                    children: [
                      field(sideAController, "Side A"),
                      const SizedBox(height: 12),
                      field(sideBController, "Side B"),
                    ],
                  ),
            const SizedBox(height: 12),
            field(heightController, "Height"),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Area Calculator",
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
            constraints: const BoxConstraints(maxWidth: 900),
            child: SizedBox(
              width: double.infinity,

              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// TITLE
                        const Text(
                          "AREA CALCULATOR",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// DROPDOWNS
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: areaType,
                                decoration: const InputDecoration(
                                  labelText: "Area Type",
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "Rectangle",
                                    child: Text("Rectangle"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Triangle",
                                    child: Text("Triangle"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Circle",
                                    child: Text("Circle"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Trapezoid",
                                    child: Text("Trapezoid"),
                                  ),
                                ],
                                onChanged: (v) => setState(() => areaType = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: unit,
                                decoration: const InputDecoration(
                                  labelText: "Unit",
                                  border: OutlineInputBorder(),
                                ),
                                items: units
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() => unit = v!),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// INPUTS
                        buildInputs(constraints.maxWidth),

                        const SizedBox(height: 24),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: calculate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Calculate Area",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

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
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
