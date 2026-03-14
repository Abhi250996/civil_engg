import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color bgColor = Color(0xFFF8FAFC);

  String measurementType = "Coordinate Distance";

  final TextEditingController x1 = TextEditingController();
  final TextEditingController y1 = TextEditingController();
  final TextEditingController x2 = TextEditingController();
  final TextEditingController y2 = TextEditingController();

  final TextEditingController length = TextEditingController();
  final TextEditingController width = TextEditingController();
  final TextEditingController height = TextEditingController();

  final TextEditingController sideA = TextEditingController();
  final TextEditingController sideB = TextEditingController();
  final TextEditingController sideC = TextEditingController();

  final TextEditingController rise = TextEditingController();
  final TextEditingController run = TextEditingController();

  double? result;

  void calculate() {
    if (!_formKey.currentState!.validate()) return;

    switch (measurementType) {
      case "Coordinate Distance":
        double dx = double.parse(x2.text) - double.parse(x1.text);
        double dy = double.parse(y2.text) - double.parse(y1.text);
        result = (dx * dx + dy * dy).sqrt();
        break;

      case "Length":
        result = double.parse(length.text);
        break;

      case "Area":
        result = double.parse(length.text) * double.parse(width.text);
        break;

      case "Triangle Area":
        double a = double.parse(sideA.text);
        double b = double.parse(sideB.text);
        double c = double.parse(sideC.text);
        double s = (a + b + c) / 2;
        result = (s * (s - a) * (s - b) * (s - c)).sqrt();
        break;

      case "Perimeter":
        result =
            double.parse(sideA.text) +
            double.parse(sideB.text) +
            double.parse(sideC.text);
        break;

      case "Slope":
        double r = double.parse(rise.text);
        double rn = double.parse(run.text);
        result = (r / rn) * 100;
        break;

      case "Volume":
        result =
            double.parse(length.text) *
            double.parse(width.text) *
            double.parse(height.text);
        break;
    }

    setState(() {});
  }

  Widget field(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      validator: (v) => Validators.validateRequired(v, label),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildInputs() {
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

      case "Length":
        return field(length, "Length");

      case "Area":
        return Column(
          children: [
            field(length, "Length"),
            const SizedBox(height: 10),
            field(width, "Width"),
          ],
        );

      case "Triangle Area":
        return Column(
          children: [
            field(sideA, "Side A"),
            const SizedBox(height: 10),
            field(sideB, "Side B"),
            const SizedBox(height: 10),
            field(sideC, "Side C"),
          ],
        );

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

      case "Slope":
        return Column(
          children: [
            field(rise, "Rise"),
            const SizedBox(height: 10),
            field(run, "Run"),
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

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text("Measurement Tool")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: measurementType,
                items: const [
                  DropdownMenuItem(
                    value: "Coordinate Distance",
                    child: Text("Coordinate Distance"),
                  ),
                  DropdownMenuItem(value: "Length", child: Text("Length")),
                  DropdownMenuItem(value: "Area", child: Text("Area")),
                  DropdownMenuItem(
                    value: "Triangle Area",
                    child: Text("Triangle Area"),
                  ),
                  DropdownMenuItem(
                    value: "Perimeter",
                    child: Text("Perimeter"),
                  ),
                  DropdownMenuItem(value: "Slope", child: Text("Slope (%)")),
                  DropdownMenuItem(value: "Volume", child: Text("Volume")),
                ],
                onChanged: (v) {
                  setState(() {
                    measurementType = v!;
                    result = null;
                  });
                },
              ),

              const SizedBox(height: 20),

              buildInputs(),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculate,
                  child: const Text("CALCULATE"),
                ),
              ),

              const SizedBox(height: 20),

              if (result != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(12),
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
                          fontSize: 34,
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
    );
  }
}

extension on double {
  double sqrt() => (this >= 0) ? (this).toDouble().pow(0.5) : 0;
}

extension on num {
  double pow(num exponent) => (this as double).pow(exponent);
}
