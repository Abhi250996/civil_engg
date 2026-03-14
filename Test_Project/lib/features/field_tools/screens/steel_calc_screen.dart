import 'package:flutter/material.dart';

class SteelCalcScreen extends StatefulWidget {
  const SteelCalcScreen({super.key});

  @override
  State<SteelCalcScreen> createState() => _SteelCalcScreenState();
}

class _SteelCalcScreenState extends State<SteelCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController barsController = TextEditingController();

  String selectedDiameter = "12";
  String selectedUnit = "Meter";

  double weightPerMeter = 0;
  double totalWeight = 0;
  double lengthInMeters = 0;

  final List<String> diameters = ["6", "8", "10", "12", "16", "20", "25", "32"];
  final List<String> units = ["Meter", "Feet", "Inch", "Yard", "Centimeter"];

  double calculateWeightPerMeter(double diameter) {
    return (diameter * diameter) / 162;
  }

  double convertToMeters(double length) {
    switch (selectedUnit) {
      case "Feet":
        return length * 0.3048;
      case "Inch":
        return length * 0.0254;
      case "Yard":
        return length * 0.9144;
      case "Centimeter":
        return length / 100;
      default:
        return length;
    }
  }

  void calculate() {
    final lengthInput = double.tryParse(lengthController.text) ?? 0;
    final bars = int.tryParse(barsController.text) ?? 0;
    final dia = double.parse(selectedDiameter);

    final lengthMeters = convertToMeters(lengthInput);
    final wpm = calculateWeightPerMeter(dia);

    setState(() {
      lengthInMeters = lengthMeters;
      weightPerMeter = wpm;
      totalWeight = wpm * lengthMeters * bars;
    });
  }

  Widget field(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
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

  Widget steelReferenceTable() {
    final data = {
      "6 mm": "0.222 kg/m",
      "8 mm": "0.395 kg/m",
      "10 mm": "0.617 kg/m",
      "12 mm": "0.888 kg/m",
      "16 mm": "1.58 kg/m",
      "20 mm": "2.47 kg/m",
      "25 mm": "3.85 kg/m",
      "32 mm": "6.31 kg/m",
    };

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 6),
            ...data.entries.map((e) => Text("${e.key} → ${e.value}")),
          ],
        ),
      ),
    );
  }

  Widget bbsPreview() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BBS Guide", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text("• Use correct bend allowance."),
            Text("• Check lap length."),
            Text("• Verify cover."),
            Text("• Follow drawing."),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text(
          "STEEL WEIGHT CALCULATOR",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedDiameter,
                          decoration: const InputDecoration(
                            labelText: "Diameter",
                            border: OutlineInputBorder(),
                          ),
                          items: diameters
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d,
                                  child: Text("$d mm"),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedDiameter = v!;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedUnit,
                          decoration: const InputDecoration(
                            labelText: "Unit",
                            border: OutlineInputBorder(),
                          ),
                          items: units
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedUnit = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: field("Bar Length", lengthController)),

                      const SizedBox(width: 10),

                      Expanded(child: field("Bars", barsController)),
                    ],
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: 150,
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
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// RESULTS
            Row(
              children: [
                resultCard(
                  "Weight/m",
                  "${weightPerMeter.toStringAsFixed(3)} kg",
                ),

                resultCard(
                  "Total Weight",
                  "${totalWeight.toStringAsFixed(2)} kg",
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "Length: ${lengthInMeters.toStringAsFixed(3)} m",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            /// BOTTOM SECTION
            Expanded(
              child: Row(
                children: [
                  steelReferenceTable(),

                  const SizedBox(width: 10),

                  bbsPreview(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
