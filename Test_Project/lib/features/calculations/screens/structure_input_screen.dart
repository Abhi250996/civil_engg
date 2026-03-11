import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/constants/route_constants.dart';
import '../controllers/calculation_controller.dart';

class HouseInputScreen extends StatefulWidget {
  const HouseInputScreen({super.key});

  @override
  State<HouseInputScreen> createState() => _HouseInputScreenState();
}

class _HouseInputScreenState extends State<HouseInputScreen> {
  final CalculationController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final args = Get.arguments ?? {};

  /// =========================
  /// CONTROLLERS
  /// =========================

  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final floorsController = TextEditingController();
  final columnSpacingController = TextEditingController();

  final tanksController = TextEditingController();
  final pumpsController = TextEditingController();
  final pipeDiameterController = TextEditingController();

  String structureSystem = "RCC";
  String foundationType = "Isolated Footing";
  String soilType = "Clay";

  /// =========================
  /// GENERATE DRAWING
  /// =========================

  void generateDrawing() {
    if (!_formKey.currentState!.validate()) return;

    final structureType = args["type"] ?? "building";

    final length = lengthController.text;
    final width = widthController.text;
    final floors = floorsController.text.isEmpty ? "1" : floorsController.text;
    final columnSpacing = columnSpacingController.text;

    final tanks = tanksController.text.isEmpty ? "0" : tanksController.text;
    final pumps = pumpsController.text.isEmpty ? "0" : pumpsController.text;
    final pipeDiameter = pipeDiameterController.text.isEmpty
        ? "0"
        : pipeDiameterController.text;

    /// Build AI prompt using user inputs
    final prompt =
        """
Generate a civil engineering layout drawing.

Site:
Length: $length meters
Width: $width meters
Soil type: $soilType

Structure:
Type: $structureType
Floors: $floors
Column spacing: $columnSpacing meters
Structure system: $structureSystem
Foundation: $foundationType

Industrial Equipment:
Tanks: $tanks
Pumps: $pumps
Pipe diameter: $pipeDiameter mm

Return JSON layout using objects:
rectangle, circle, line, pipe, equipment, dimension, text.
""";

    controller.generateAIDrawing(prompt);

    Get.toNamed(RouteConstants.drawingResult);
  }

  @override
  Widget build(BuildContext context) {
    final structureType = args["type"] ?? "building";

    return Scaffold(
      appBar: AppBar(title: Text("Inputs - $structureType")),

      body: Center(
        child: SizedBox(
          width: 600,

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: SingleChildScrollView(
              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    /// =========================
                    /// SITE DETAILS
                    /// =========================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Site Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: lengthController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          Validators.validatePositiveNumber(value, "Length"),
                      decoration: const InputDecoration(
                        labelText: "Plot Length (m)",
                        prefixIcon: Icon(Icons.straighten),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          Validators.validatePositiveNumber(value, "Width"),
                      decoration: const InputDecoration(
                        labelText: "Plot Width (m)",
                        prefixIcon: Icon(Icons.square_foot),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField(
                      value: soilType,
                      items: const [
                        DropdownMenuItem(value: "Clay", child: Text("Clay")),
                        DropdownMenuItem(value: "Sand", child: Text("Sand")),
                        DropdownMenuItem(
                          value: "Gravel",
                          child: Text("Gravel"),
                        ),
                        DropdownMenuItem(value: "Rock", child: Text("Rock")),
                      ],
                      onChanged: (v) => soilType = v.toString(),
                      decoration: const InputDecoration(
                        labelText: "Soil Type",
                        prefixIcon: Icon(Icons.landscape),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// STRUCTURE DETAILS
                    /// =========================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Structure Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: floorsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Floors",
                        prefixIcon: Icon(Icons.apartment),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: columnSpacingController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validatePositiveNumber(
                        value,
                        "Column Spacing",
                      ),
                      decoration: const InputDecoration(
                        labelText: "Column Spacing (m)",
                        prefixIcon: Icon(Icons.grid_on),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField(
                      value: structureSystem,
                      items: const [
                        DropdownMenuItem(value: "RCC", child: Text("RCC")),
                        DropdownMenuItem(value: "Steel", child: Text("Steel")),
                        DropdownMenuItem(
                          value: "Composite",
                          child: Text("Composite"),
                        ),
                      ],
                      onChanged: (v) => structureSystem = v.toString(),
                      decoration: const InputDecoration(
                        labelText: "Structure System",
                        prefixIcon: Icon(Icons.account_tree),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField(
                      value: foundationType,
                      items: const [
                        DropdownMenuItem(
                          value: "Isolated Footing",
                          child: Text("Isolated Footing"),
                        ),
                        DropdownMenuItem(
                          value: "Raft Foundation",
                          child: Text("Raft Foundation"),
                        ),
                        DropdownMenuItem(
                          value: "Pile Foundation",
                          child: Text("Pile Foundation"),
                        ),
                      ],
                      onChanged: (v) => foundationType = v.toString(),
                      decoration: const InputDecoration(
                        labelText: "Foundation Type",
                        prefixIcon: Icon(Icons.foundation),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// INDUSTRIAL EQUIPMENT
                    /// =========================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Industrial Equipment (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: tanksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Tanks",
                        prefixIcon: Icon(Icons.circle),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: pumpsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Pumps",
                        prefixIcon: Icon(Icons.settings),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: pipeDiameterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Pipe Diameter (mm)",
                        prefixIcon: Icon(Icons.linear_scale),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// GENERATE BUTTON
                    /// =========================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: generateDrawing,
                        child: const Text("Generate Engineering Drawing"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
