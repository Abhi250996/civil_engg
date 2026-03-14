import 'package:flutter/material.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController inputController = TextEditingController();

  String selectedCategory = "Length";
  String fromUnit = "Meter";
  String toUnit = "Feet";

  double result = 0;

  final Map<String, Map<String, double>> conversionTable = {
    "Length": {
      "Meter": 1,
      "Centimeter": 0.01,
      "Millimeter": 0.001,
      "Feet": 0.3048,
      "Inch": 0.0254,
    },
    "Area": {"Sq Meter": 1, "Sq Feet": 0.092903, "Sq Yard": 0.836127},
    "Volume": {"Cubic Meter": 1, "Cubic Feet": 0.0283168, "Liter": 0.001},
    "Weight": {"Kilogram": 1, "Gram": 0.001, "Ton": 1000, "Pound": 0.453592},
  };

  void convert() {
    final input = double.tryParse(inputController.text) ?? 0;

    final fromFactor = conversionTable[selectedCategory]![fromUnit]!;
    final toFactor = conversionTable[selectedCategory]![toUnit]!;

    final baseValue = input * fromFactor;

    setState(() {
      result = baseValue / toFactor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = conversionTable[selectedCategory]!.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Multi Unit Converter")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// CATEGORY DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: conversionTable.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              decoration: const InputDecoration(labelText: "Category"),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  fromUnit = conversionTable[value]!.keys.first;
                  toUnit = conversionTable[value]!.keys.last;
                });
              },
            ),

            const SizedBox(height: 20),

            /// INPUT VALUE
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Value",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// FROM UNIT
            DropdownButtonFormField<String>(
              value: fromUnit,
              items: units
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              decoration: const InputDecoration(labelText: "From Unit"),
              onChanged: (value) {
                setState(() {
                  fromUnit = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// TO UNIT
            DropdownButtonFormField<String>(
              value: toUnit,
              items: units
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              decoration: const InputDecoration(labelText: "To Unit"),
              onChanged: (value) {
                setState(() {
                  toUnit = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(onPressed: convert, child: const Text("Convert")),

            const SizedBox(height: 30),

            /// RESULT
            Text(
              "Result: ${result.toStringAsFixed(4)} $toUnit",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
