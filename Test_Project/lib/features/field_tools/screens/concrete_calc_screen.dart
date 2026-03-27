import 'package:flutter/material.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';

class ConcreteCalcScreen extends StatefulWidget {
  const ConcreteCalcScreen({super.key});

  @override
  State<ConcreteCalcScreen> createState() => _ConcreteCalcScreenState();
}

class _ConcreteCalcScreenState extends State<ConcreteCalcScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  String structureType = "Slab";
  String mixRatio = "1:2:4";
  String unit = "Meter";

  /// ✅ FIXED NAMES
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final depthController = TextEditingController();
  final stepsController = TextEditingController();

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
    double l = convertToMeters(double.tryParse(lengthController.text) ?? 0);
    double w = convertToMeters(double.tryParse(widthController.text) ?? 0);
    double h = convertToMeters(double.tryParse(heightController.text) ?? 0);
    double d = convertToMeters(double.tryParse(depthController.text) ?? 0);
    double s = double.tryParse(stepsController.text) ?? 0;

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
      default:
        volume = l * w * h;
    }

    double dryVolume = volume * 1.54;
    var ratio = ratios[mixRatio]!;

    double total =
        ratio[0].toDouble() + ratio[1].toDouble() + ratio[2].toDouble();

    cement = (dryVolume * ratio[0] / total) * 1440 / 50;
    sand = dryVolume * ratio[1] / total;
    aggregate = dryVolume * ratio[2] / total;

    setState(() {});
  }

  void resetFields() {
    lengthController.clear();
    widthController.clear();
    heightController.clear();
    depthController.clear();
    stepsController.clear();

    volume = cement = sand = aggregate = 0;
    setState(() {});
  }

  /// ================= UI =================

  bool isDesktop(double width) => width > 800;

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

  Widget structureInputs(double width) {
    final desktop = isDesktop(width);

    Widget row2(Widget a, Widget b) => desktop
        ? Row(
            children: [
              Expanded(child: a),
              const SizedBox(width: 12),
              Expanded(child: b),
            ],
          )
        : Column(children: [a, const SizedBox(height: 12), b]);

    switch (structureType) {
      case "Slab":
        return Column(
          children: [
            row2(
              field(lengthController, "Length ($unit)"),
              field(widthController, "Width ($unit)"),
            ),
            const SizedBox(height: 12),
            field(depthController, "Thickness ($unit)"),
          ],
        );

      case "Staircase":
        return Column(
          children: [
            row2(
              field(lengthController, "Step Length"),
              field(widthController, "Step Width"),
            ),
            const SizedBox(height: 12),
            row2(
              field(heightController, "Step Height"),
              field(stepsController, "Steps"),
            ),
          ],
        );

      default:
        return Column(
          children: [
            row2(
              field(lengthController, "Length"),
              field(widthController, "Width"),
            ),
            const SizedBox(height: 12),
            field(heightController, "Height"),
          ],
        );
    }
  }

  Widget resultTile(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Concrete Calculator",
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
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "CONCRETE CALCULATOR",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// DROPDOWNS
                          DropdownButtonFormField<String>(
                            value: structureType,
                            decoration: const InputDecoration(
                              labelText: "Structure Type",
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "Slab",
                                child: Text("Slab"),
                              ),
                              DropdownMenuItem(
                                value: "Beam",
                                child: Text("Beam"),
                              ),
                              DropdownMenuItem(
                                value: "Column",
                                child: Text("Column"),
                              ),
                              DropdownMenuItem(
                                value: "Footing",
                                child: Text("Footing"),
                              ),
                              DropdownMenuItem(
                                value: "Staircase",
                                child: Text("Staircase"),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => structureType = v!),
                          ),

                          const SizedBox(height: 12),

                          DropdownButtonFormField<String>(
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

                          const SizedBox(height: 12),

                          DropdownButtonFormField<String>(
                            value: mixRatio,
                            decoration: const InputDecoration(
                              labelText: "Mix Ratio",
                              border: OutlineInputBorder(),
                            ),
                            items: ratios.keys
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => mixRatio = v!),
                          ),

                          const SizedBox(height: 20),

                          /// INPUTS
                          structureInputs(constraints.maxWidth),

                          const SizedBox(height: 20),

                          /// BUTTONS
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: calculate,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentBlue,
                                  ),
                                  child: const Text(
                                    "Calculate",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: resetFields,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: const Text(
                                    "Reset",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          if (volume > 0) ...[
                            resultTile(
                              "Volume",
                              "${volume.toStringAsFixed(3)} m³",
                            ),
                            resultTile(
                              "Cement",
                              "${cement.toStringAsFixed(1)} Bags",
                            ),
                            resultTile("Sand", "${sand.toStringAsFixed(2)} m³"),
                            resultTile(
                              "Aggregate",
                              "${aggregate.toStringAsFixed(2)} m³",
                            ),
                          ],
                        ],
                      ),
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
