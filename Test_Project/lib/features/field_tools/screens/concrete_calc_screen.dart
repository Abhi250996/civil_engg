import 'package:flutter/material.dart';

class ConcreteCalcScreen extends StatefulWidget {
  const ConcreteCalcScreen({super.key});

  @override
  State<ConcreteCalcScreen> createState() => _ConcreteCalcScreenState();
}

class _ConcreteCalcScreenState extends State<ConcreteCalcScreen> {
  String structureType = "Slab";
  String mixRatio = "1:2:4";

  final length = TextEditingController();
  final width = TextEditingController();
  final height = TextEditingController();
  final depth = TextEditingController();
  final steps = TextEditingController();

  double volume = 0;
  double cement = 0;
  double sand = 0;
  double aggregate = 0;

  final ratios = {
    "1:2:4": [1, 2, 4],
    "1:1.5:3": [1, 1.5, 3],
    "1:3:6": [1, 3, 6],
  };

  void calculate() {
    double l = double.tryParse(length.text) ?? 0;
    double w = double.tryParse(width.text) ?? 0;
    double h = double.tryParse(height.text) ?? 0;
    double d = double.tryParse(depth.text) ?? 0;
    double s = double.tryParse(steps.text) ?? 0;

    /// STRUCTURE TYPES

    switch (structureType) {
      case "Slab":
        volume = l * w * d;
        break;

      case "Beam":
        volume = l * w * h;
        break;

      case "Column":
        volume = l * w * h;
        break;

      case "Footing":
        volume = l * w * h;
        break;

      case "Staircase":
        volume = (l * w * h) * s;
        break;

      case "Plain Volume":
        volume = l * w * h;
        break;
    }

    /// DRY VOLUME
    double dryVolume = volume * 1.54;

    var ratio = ratios[mixRatio]!;

    double total =
        ratio[0].toDouble() + ratio[1].toDouble() + ratio[2].toDouble();
    double cementVol = dryVolume * ratio[0] / total;
    double sandVol = dryVolume * ratio[1] / total;
    double aggVol = dryVolume * ratio[2] / total;

    cement = cementVol * 1440 / 50;
    sand = sandVol;
    aggregate = aggVol;

    setState(() {});
  }

  Widget field(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget resultTile(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget structureInputs() {
    switch (structureType) {
      case "Slab":
        return Column(
          children: [
            field(length, "Length (m)"),
            const SizedBox(height: 10),
            field(width, "Width (m)"),
            const SizedBox(height: 10),
            field(depth, "Thickness (m)"),
          ],
        );

      case "Beam":
      case "Column":
      case "Footing":
        return Column(
          children: [
            field(length, "Length (m)"),
            const SizedBox(height: 10),
            field(width, "Width (m)"),
            const SizedBox(height: 10),
            field(height, "Height (m)"),
          ],
        );

      case "Staircase":
        return Column(
          children: [
            field(length, "Step Length"),
            const SizedBox(height: 10),
            field(width, "Step Width"),
            const SizedBox(height: 10),
            field(height, "Step Height"),
            const SizedBox(height: 10),
            field(steps, "Number of Steps"),
          ],
        );

      default:
        return field(length, "Value");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Concrete Calculator")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// STRUCTURE TYPE
            DropdownButtonFormField(
              value: structureType,
              decoration: const InputDecoration(
                labelText: "Structure Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Slab", child: Text("Slab")),
                DropdownMenuItem(value: "Beam", child: Text("Beam")),
                DropdownMenuItem(value: "Column", child: Text("Column")),
                DropdownMenuItem(value: "Footing", child: Text("Footing")),
                DropdownMenuItem(value: "Staircase", child: Text("Staircase")),
                DropdownMenuItem(
                  value: "Plain Volume",
                  child: Text("Plain Volume"),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  structureType = v!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// MIX RATIO
            DropdownButtonFormField(
              value: mixRatio,
              decoration: const InputDecoration(
                labelText: "Mix Ratio",
                border: OutlineInputBorder(),
              ),
              items: ratios.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  mixRatio = v!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// INPUTS
            structureInputs(),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculate,
                child: const Text("CALCULATE MATERIAL"),
              ),
            ),

            const SizedBox(height: 20),

            if (volume > 0)
              Column(
                children: [
                  resultTile(
                    "Concrete Volume",
                    "${volume.toStringAsFixed(3)} m³",
                  ),

                  resultTile(
                    "Cement Required",
                    "${cement.toStringAsFixed(1)} Bags",
                  ),

                  resultTile("Sand Required", "${sand.toStringAsFixed(2)} m³"),

                  resultTile(
                    "Aggregate Required",
                    "${aggregate.toStringAsFixed(2)} m³",
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
