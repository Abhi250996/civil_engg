import 'package:flutter/material.dart';

class ConcreteCalcScreen extends StatefulWidget {
  const ConcreteCalcScreen({super.key});

  @override
  State<ConcreteCalcScreen> createState() => _ConcreteCalcScreenState();
}

class _ConcreteCalcScreenState extends State<ConcreteCalcScreen> {
  /// THEME
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  String structureType = "Slab";
  String mixRatio = "1:2:4";
  String unit = "Meter";

  final length = TextEditingController();
  final width = TextEditingController();
  final height = TextEditingController();
  final depth = TextEditingController();
  final steps = TextEditingController();

  double volume = 0;
  double cement = 0;
  double sand = 0;
  double aggregate = 0;

  final units = ["Meter", "Feet", "Inch", "Yard", "Centimeter"];

  final ratios = {
    "1:2:4": [1, 2, 4],
    "1:1.5:3": [1, 1.5, 3],
    "1:3:6": [1, 3, 6],
  };

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
    double l = convertToMeters(double.tryParse(length.text) ?? 0);
    double w = convertToMeters(double.tryParse(width.text) ?? 0);
    double h = convertToMeters(double.tryParse(height.text) ?? 0);
    double d = convertToMeters(double.tryParse(depth.text) ?? 0);
    double s = double.tryParse(steps.text) ?? 0;

    switch (structureType) {
      case "Slab":
        volume = l * w * d;
        break;

      case "Beam":
      case "Column":
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

  void resetFields() {
    length.clear();
    width.clear();
    height.clear();
    depth.clear();
    steps.clear();

    volume = 0;
    cement = 0;
    sand = 0;
    aggregate = 0;

    setState(() {});
  }

  Widget field(TextEditingController c, String label) {
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

  Widget resultTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget structureInputs() {
    switch (structureType) {
      case "Slab":
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: field(length, "Length ($unit)")),
                const SizedBox(width: 10),
                Expanded(child: field(width, "Width ($unit)")),
              ],
            ),

            const SizedBox(height: 12),

            Row(children: [Expanded(child: field(depth, "Thickness ($unit)"))]),
          ],
        );

      case "Beam":
      case "Column":
      case "Footing":
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: field(length, "Length ($unit)")),
                const SizedBox(width: 10),
                Expanded(child: field(width, "Width ($unit)")),
              ],
            ),

            const SizedBox(height: 12),

            Row(children: [Expanded(child: field(height, "Height ($unit)"))]),
          ],
        );

      case "Staircase":
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: field(length, "Step Length ($unit)")),
                const SizedBox(width: 10),
                Expanded(child: field(width, "Step Width ($unit)")),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: field(height, "Step Height ($unit)")),
                const SizedBox(width: 10),
                Expanded(child: field(steps, "Steps")),
              ],
            ),
          ],
        );

      default:
        return field(length, "Value ($unit)");
    }
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
          "CONCRETE CALCULATOR",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// MAIN CARD
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),

              child: Column(
                children: [
                  DropdownButtonFormField(
                    initialValue: structureType,
                    decoration: const InputDecoration(
                      labelText: "Structure Type",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Slab", child: Text("Slab")),
                      DropdownMenuItem(value: "Beam", child: Text("Beam")),
                      DropdownMenuItem(value: "Column", child: Text("Column")),
                      DropdownMenuItem(
                        value: "Footing",
                        child: Text("Footing"),
                      ),
                      DropdownMenuItem(
                        value: "Staircase",
                        child: Text("Staircase"),
                      ),
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

                  const SizedBox(height: 14),

                  DropdownButtonFormField(
                    initialValue: unit,
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

                  const SizedBox(height: 14),

                  DropdownButtonFormField(
                    initialValue: mixRatio,
                    decoration: const InputDecoration(
                      labelText: "Concrete Mix Ratio",
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

                  const SizedBox(height: 18),

                  structureInputs(),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

                      const SizedBox(width: 10),

                      SizedBox(
                        width: 150,
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

            const SizedBox(height: 25),

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
