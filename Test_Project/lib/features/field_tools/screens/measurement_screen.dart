import 'package:flutter/material.dart';

import '../../../core/utils/calculation_utils.dart';
import '../../../core/utils/validators.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController x1Controller = TextEditingController();
  final TextEditingController y1Controller = TextEditingController();
  final TextEditingController x2Controller = TextEditingController();
  final TextEditingController y2Controller = TextEditingController();

  double? distance;

  /// =========================
  /// CALCULATE DISTANCE
  /// =========================

  void calculateDistance() {
    if (!_formKey.currentState!.validate()) return;

    double x1 = double.parse(x1Controller.text);
    double y1 = double.parse(y1Controller.text);
    double x2 = double.parse(x2Controller.text);
    double y2 = double.parse(y2Controller.text);

    setState(() {
      distance = CalculationUtils.distanceBetweenPoints(
        x1: x1,
        y1: y1,
        x2: x2,
        y2: y2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Distance Measurement")),

      body: Center(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// POINT 1
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Point 1",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: x1Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validators.validateRequired(value, "X1"),
                          decoration: const InputDecoration(labelText: "X1"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextFormField(
                          controller: y1Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validators.validateRequired(value, "Y1"),
                          decoration: const InputDecoration(labelText: "Y1"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// POINT 2
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Point 2",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: x2Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validators.validateRequired(value, "X2"),
                          decoration: const InputDecoration(labelText: "X2"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextFormField(
                          controller: y2Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validators.validateRequired(value, "Y2"),
                          decoration: const InputDecoration(labelText: "Y2"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// CALCULATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: calculateDistance,
                      child: const Text("Calculate Distance"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// RESULT
                  if (distance != null)
                    Text(
                      "Distance: ${distance!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
