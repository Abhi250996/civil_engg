import 'package:flutter/material.dart';

class SteelCalcScreen extends StatefulWidget {
  const SteelCalcScreen({super.key});

  @override
  State<SteelCalcScreen> createState() => _SteelCalcScreenState();
}

class _SteelCalcScreenState extends State<SteelCalcScreen> {
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController barsController = TextEditingController();

  String selectedDiameter = "12";

  double weightPerMeter = 0;
  double totalWeight = 0;

  final List<String> diameters = ["6", "8", "10", "12", "16", "20", "25", "32"];

  /// Weight per meter formula
  double calculateWeightPerMeter(double diameter) {
    return (diameter * diameter) / 162;
  }

  void calculate() {
    final length = double.tryParse(lengthController.text) ?? 0;
    final bars = int.tryParse(barsController.text) ?? 0;
    final dia = double.parse(selectedDiameter);

    final wpm = calculateWeightPerMeter(dia);

    setState(() {
      weightPerMeter = wpm;
      totalWeight = wpm * length * bars;
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
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget resultCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade200),
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
            "Steel Weight Reference",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ...data.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("${e.key}  →  ${e.value}"),
            ),
          ),
        ],
      ),
    );
  }

  Widget bbsPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bar Bending Schedule (Preview)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text("• Use correct bend allowance."),
          Text("• Check lap length for splicing."),
          Text("• Verify cover requirements."),
          Text("• Ensure structural drawing compliance."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Steel Weight Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// DIAMETER
            DropdownButtonFormField<String>(
              value: selectedDiameter,
              decoration: const InputDecoration(
                labelText: "Bar Diameter (mm)",
                border: OutlineInputBorder(),
              ),
              items: diameters
                  .map((d) => DropdownMenuItem(value: d, child: Text("$d mm")))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDiameter = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// LENGTH
            inputField("Bar Length (m)", lengthController, "Example: 12"),

            const SizedBox(height: 20),

            /// NUMBER OF BARS
            inputField("Number of Bars", barsController, "Example: 10"),

            const SizedBox(height: 25),

            /// CALCULATE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculate,
                child: const Text("Calculate Steel Weight"),
              ),
            ),

            const SizedBox(height: 30),

            /// RESULTS
            Row(
              children: [
                resultCard(
                  "Weight / Meter",
                  "${weightPerMeter.toStringAsFixed(3)} kg",
                ),
                resultCard(
                  "Total Weight",
                  "${totalWeight.toStringAsFixed(2)} kg",
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// REFERENCE TABLE
            steelReferenceTable(),

            const SizedBox(height: 30),

            /// BBS GUIDE
            bbsPreview(),
          ],
        ),
      ),
    );
  }
}
