import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_project/core/utils/app_scaffold.dart';
import '../../../core/utils/validators.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  String measurementType = "Coordinate Distance";
  String unit = "Meter";

  final units = ["Meter", "Feet", "Inch", "Yard", "Centimeter"];

  final x1 = TextEditingController();
  final y1 = TextEditingController();
  final x2 = TextEditingController();
  final y2 = TextEditingController();

  final length = TextEditingController();
  final width = TextEditingController();
  final height = TextEditingController();

  final sideA = TextEditingController();
  final sideB = TextEditingController();
  final sideC = TextEditingController();

  final rise = TextEditingController();
  final run = TextEditingController();

  double? result;

  double convertToMeters(double value) {
    switch (unit) {
      case "Feet":
        return value * 0.3048;
      case "Inch":
        return value * 0.0254;
      case "Yard":
        return value * 0.9144;
      case "Centimeter":
        return value / 100;
      default:
        return value;
    }
  }

  void calculate() {
    if (!_formKey.currentState!.validate()) return;

    switch (measurementType) {
      case "Coordinate Distance":
        double dx =
            convertToMeters(double.parse(x2.text)) -
            convertToMeters(double.parse(x1.text));
        double dy =
            convertToMeters(double.parse(y2.text)) -
            convertToMeters(double.parse(y1.text));
        result = sqrt(dx * dx + dy * dy);
        break;

      case "Length":
        result = convertToMeters(double.parse(length.text));
        break;

      case "Area":
        result =
            convertToMeters(double.parse(length.text)) *
            convertToMeters(double.parse(width.text));
        break;

      case "Triangle Area":
        double a = convertToMeters(double.parse(sideA.text));
        double b = convertToMeters(double.parse(sideB.text));
        double c = convertToMeters(double.parse(sideC.text));
        double s = (a + b + c) / 2;
        result = sqrt(s * (s - a) * (s - b) * (s - c));
        break;

      case "Perimeter":
        result =
            convertToMeters(double.parse(sideA.text)) +
            convertToMeters(double.parse(sideB.text)) +
            convertToMeters(double.parse(sideC.text));
        break;

      case "Slope":
        result = (double.parse(rise.text) / double.parse(run.text)) * 100;
        break;

      case "Volume":
        result =
            convertToMeters(double.parse(length.text)) *
            convertToMeters(double.parse(width.text)) *
            convertToMeters(double.parse(height.text));
        break;
    }

    setState(() {});
  }

  void resetFields() {
    x1.clear();
    y1.clear();
    x2.clear();
    y2.clear();
    length.clear();
    width.clear();
    height.clear();
    sideA.clear();
    sideB.clear();
    sideC.clear();
    rise.clear();
    run.clear();
    result = null;
    setState(() {});
  }

  Widget field(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      validator: (v) => Validators.validateRequired(v, label),
      decoration: InputDecoration(
        labelText: "$label ($unit)",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget dropdown(String label, String value, List items, Function onChanged) {
    return DropdownButtonFormField(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v),
    );
  }

  Widget inputs() {
    switch (measurementType) {
      case "Coordinate Distance":
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: field(x1, "X1")),
                const SizedBox(width: 10),
                Expanded(child: field(y1, "Y1")),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: field(x2, "X2")),
                const SizedBox(width: 10),
                Expanded(child: field(y2, "Y2")),
              ],
            ),
          ],
        );

      case "Area":
        return Column(
          children: [
            field(length, "Length"),
            const SizedBox(height: 10),
            field(width, "Width"),
          ],
        );

      case "Volume":
        return Column(
          children: [
            field(length, "Length"),
            const SizedBox(height: 10),
            field(width, "Width"),
            const SizedBox(height: 10),
            field(height, "Height"),
          ],
        );

      case "Slope":
        return Column(
          children: [
            field(rise, "Rise"),
            const SizedBox(height: 10),
            field(run, "Run"),
          ],
        );

      case "Triangle Area":
      case "Perimeter":
        return Column(
          children: [
            field(sideA, "Side A"),
            const SizedBox(height: 10),
            field(sideB, "Side B"),
            const SizedBox(height: 10),
            field(sideC, "Side C"),
          ],
        );

      default:
        return field(length, "Length");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Measurement Tools",
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

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// HEADER
                  const Text(
                    "MEASUREMENT TOOL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            /// INPUT CARD
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  dropdown(
                                    "Measurement Type",
                                    measurementType,
                                    [
                                      "Coordinate Distance",
                                      "Length",
                                      "Area",
                                      "Triangle Area",
                                      "Perimeter",
                                      "Slope",
                                      "Volume",
                                    ],
                                    (v) {
                                      setState(() {
                                        measurementType = v;
                                        result = null;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  dropdown("Unit", unit, units, (v) {
                                    setState(() {
                                      unit = v;
                                    });
                                  }),

                                  const SizedBox(height: 20),

                                  inputs(),

                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: calculate,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: accentBlue,
                                          ),
                                          child: const Text("CALCULATE"),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: resetFields,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                          ),
                                          child: const Text("RESET"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// RESULT
                            if (result != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: primaryBlue,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "RESULT",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      result!.toStringAsFixed(3),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
