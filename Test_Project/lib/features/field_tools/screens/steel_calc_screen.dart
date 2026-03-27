import 'package:flutter/material.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';

class SteelCalcScreen extends StatefulWidget {
  const SteelCalcScreen({super.key});

  @override
  State<SteelCalcScreen> createState() => _SteelCalcScreenState();
}

class _SteelCalcScreenState extends State<SteelCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  final lengthController = TextEditingController();
  final barsController = TextEditingController();

  String selectedDiameter = "12";
  String selectedUnit = "Meter";

  double weightPerMeter = 0;
  double totalWeight = 0;
  double lengthInMeters = 0;

  final diameters = ["6", "8", "10", "12", "16", "20", "25", "32"];
  final units = ["Meter", "Feet", "Inch", "Yard", "Centimeter"];

  double calculateWeightPerMeter(double d) => (d * d) / 162;

  double convertToMeters(double value) {
    switch (selectedUnit) {
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
    final len = convertToMeters(double.tryParse(lengthController.text) ?? 0);
    final bars = int.tryParse(barsController.text) ?? 0;
    final dia = double.parse(selectedDiameter);

    final wpm = calculateWeightPerMeter(dia);

    setState(() {
      lengthInMeters = len;
      weightPerMeter = wpm;
      totalWeight = wpm * len * bars;
    });
  }

  /// ================= UI =================

  Widget field(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
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

  Widget referenceCard() {
    final data = {
      "6 mm": "0.222",
      "8 mm": "0.395",
      "10 mm": "0.617",
      "12 mm": "0.888",
      "16 mm": "1.58",
      "20 mm": "2.47",
      "25 mm": "3.85",
      "32 mm": "6.31",
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Steel Reference",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...data.entries.map((e) => Text("${e.key} → ${e.value} kg/m")),
        ],
      ),
    );
  }

  Widget bbsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("BBS Guide", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Bend allowance"),
          Text("• Lap length"),
          Text("• Check cover"),
          Text("• Follow drawing"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return AppScaffold(
      title: "Steel Calculator",
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
                    "STEEL CALCULATOR",
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
                                  child: DropdownButtonFormField(
                                    value: selectedDiameter,
                                    items: diameters
                                        .map(
                                          (d) => DropdownMenuItem(
                                            value: d,
                                            child: Text("$d mm"),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedDiameter = v!),
                                    decoration: const InputDecoration(
                                      labelText: "Diameter",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: selectedUnit,
                                    items: units
                                        .map(
                                          (u) => DropdownMenuItem(
                                            value: u,
                                            child: Text(u),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedUnit = v!),
                                    decoration: const InputDecoration(
                                      labelText: "Unit",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: field("Bar Length", lengthController),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: field("Bars", barsController)),
                              ],
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: calculate,
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
                                resultCard(
                                  "Weight/m",
                                  "${weightPerMeter.toStringAsFixed(3)} kg",
                                ),
                                resultCard(
                                  "Total",
                                  "${totalWeight.toStringAsFixed(2)} kg",
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Length: ${lengthInMeters.toStringAsFixed(3)} m",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// BOTTOM SECTION
                            isDesktop
                                ? Row(
                                    children: [
                                      Expanded(child: referenceCard()),
                                      const SizedBox(width: 12),
                                      Expanded(child: bbsCard()),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      referenceCard(),
                                      const SizedBox(height: 12),
                                      bbsCard(),
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
