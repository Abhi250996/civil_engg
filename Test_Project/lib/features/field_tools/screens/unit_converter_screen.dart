import 'package:flutter/material.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  /// SAME THEME
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

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
      "Foot": 0.3048,
      "Inch": 0.0254,
      "Yard": 0.9144,
      "Yards": 0.9144,
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

  Widget dropdown(String label, String value, List items, Function onChanged) {
    return DropdownButtonFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v),
    );
  }

  Widget smallButton({required String title, required VoidCallback onTap}) {
    return SizedBox(
      height: 36,

      width: 150,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final units = conversionTable[selectedCategory]!.keys.toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryBlue,

        elevation: 0,
        title: const Text(
          "UNIT CONVERTER",
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
            /// MAIN TOOL CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  /// CATEGORY + INPUT
                  Row(
                    children: [
                      Expanded(
                        child: dropdown(
                          "Category",
                          selectedCategory,
                          conversionTable.keys.toList(),
                          (value) {
                            setState(() {
                              selectedCategory = value;
                              fromUnit = conversionTable[value]!.keys.first;
                              toUnit = conversionTable[value]!.keys.last;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Value",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// FROM + TO
                  Row(
                    children: [
                      Expanded(
                        child: dropdown("From Unit", fromUnit, units, (value) {
                          setState(() {
                            fromUnit = value;
                          });
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dropdown("To Unit", toUnit, units, (value) {
                          setState(() {
                            toUnit = value;
                          });
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  smallButton(title: "CONVERT", onTap: convert),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// RESULT CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Text(
                    "RESULT",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.toStringAsFixed(4),
                    style: const TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(toUnit, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
