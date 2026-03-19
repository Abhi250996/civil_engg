import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_project/core/utils/app_scaffold.dart';

class SlopeCalcScreen extends StatefulWidget {
  const SlopeCalcScreen({super.key});

  @override
  State<SlopeCalcScreen> createState() => _SlopeCalcScreenState();
}

class _SlopeCalcScreenState extends State<SlopeCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

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
      slopePercent = (rise / run) * 100;
      slopeAngle = atan(rise / run) * 180 / pi;
      slopeRatio = rise == 0 ? 0 : run / rise;
    });
  }

  /// ================= UI =================

  Widget field(String label, TextEditingController c) {
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget guide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Slope Guide", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Road: 2% – 6%"),
          Text("• Roof: 1:40"),
          Text("• Ramp: 1:12"),
          Text("• Railway: 1:100"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Slope Calculator",
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
                    "SLOPE CALCULATOR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MAIN CARD
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
                            /// UNIT
                            DropdownButtonFormField(
                              value: unit,
                              items: units
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => unit = v!),
                              decoration: const InputDecoration(
                                labelText: "Unit",
                                border: OutlineInputBorder(),
                              ),
                            ),

                            const SizedBox(height: 16),

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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentBlue,
                                ),
                                child: const Text("CALCULATE"),
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// RESULTS GRID
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                resultCard(
                                  "Slope %",
                                  "${slopePercent.toStringAsFixed(2)}%",
                                ),
                                resultCard(
                                  "Angle",
                                  "${slopeAngle.toStringAsFixed(2)}°",
                                ),
                                resultCard(
                                  "Ratio",
                                  "1 : ${slopeRatio.toStringAsFixed(2)}",
                                ),
                                resultCard("Gradient", "Rise/Run"),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// GUIDE
                            guide(),
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
