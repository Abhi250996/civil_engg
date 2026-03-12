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

  /// PROJECT
  final projectNameController = TextEditingController();

  String unitSystem = "Metric";
  String drawingScale = "1:100";
  String northDirection = "North";

  /// SITE
  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  String soilType = "Clay";

  /// STRUCTURE
  final floorsController = TextEditingController();
  final columnSpacingController = TextEditingController();
  String structureSystem = "RCC";
  String foundationType = "Isolated Footing";

  /// GRID
  final gridSpacingController = TextEditingController();

  /// LEVELS
  final plinthLevelController = TextEditingController();
  final floorHeightController = TextEditingController();

  /// MATERIAL
  String concreteGrade = "M25";
  String steelGrade = "Fe500";

  /// ROAD
  final roadWidthController = TextEditingController();
  final drainSlopeController = TextEditingController();
  final descriptionController = TextEditingController();

  /// UTILITIES
  bool waterSupply = true;
  bool sewerSystem = true;
  bool electricalLayout = true;
  bool hvacSystem = false;

  /// INDUSTRIAL
  final tanksController = TextEditingController();
  final pumpsController = TextEditingController();
  final pipeDiameterController = TextEditingController();

  void generateDrawing() {
    if (!_formKey.currentState!.validate()) return;

    final customDescription = descriptionController.text.trim();

    final prompt =
        """
Generate a professional civil engineering drawing.

Project:
Name: ${projectNameController.text}
Units: $unitSystem
Scale: $drawingScale
North: $northDirection

Site:
Length: ${lengthController.text} m
Width: ${widthController.text} m
Soil type: $soilType

Structure:
Floors: ${floorsController.text}
Column spacing: ${columnSpacingController.text} m
Structure system: $structureSystem
Foundation: $foundationType

Grid:
Grid spacing: ${gridSpacingController.text} m

Levels:
Plinth level: ${plinthLevelController.text} m
Floor height: ${floorHeightController.text} m

Materials:
Concrete: $concreteGrade
Steel: $steelGrade

Road:
Road width: ${roadWidthController.text} m
Drain slope: ${drainSlopeController.text} %

Utilities:
Water supply: $waterSupply
Sewer system: $sewerSystem
Electrical: $electricalLayout
HVAC: $hvacSystem

Industrial Equipment:
Tanks: ${tanksController.text}
Pumps: ${pumpsController.text}
Pipe diameter: ${pipeDiameterController.text} mm

${customDescription.isNotEmpty ? """

Engineer Special Instructions:
$customDescription

IMPORTANT:
Prioritize these instructions while generating the layout.

""" : ""}

Return structured drawing objects using:
rectangle, line, circle, pipe, equipment, dimension, text.
""";

    controller.generateAIDrawing(prompt);
    Get.toNamed(RouteConstants.drawingResult);
  }

  Widget sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Civil Engineering Inputs")),
      body: Center(
        child: SizedBox(
          width: 700,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// PROJECT
                    sectionTitle("Project Information"),
                    TextFormField(
                      controller: projectNameController,
                      decoration: const InputDecoration(
                        labelText: "Project Name",
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField(
                      value: unitSystem,
                      items: const [
                        DropdownMenuItem(
                          value: "Metric",
                          child: Text("Metric (m, mm)"),
                        ),
                        DropdownMenuItem(
                          value: "Imperial",
                          child: Text("Imperial (ft, in)"),
                        ),
                      ],
                      onChanged: (v) => unitSystem = v.toString(),
                      decoration: const InputDecoration(
                        labelText: "Unit System",
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// SITE
                    sectionTitle("Site Details"),

                    TextFormField(
                      controller: lengthController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          Validators.validatePositiveNumber(v, "Length"),
                      decoration: const InputDecoration(
                        labelText: "Plot Length (m)",
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          Validators.validatePositiveNumber(v, "Width"),
                      decoration: const InputDecoration(
                        labelText: "Plot Width (m)",
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
                      decoration: const InputDecoration(labelText: "Soil Type"),
                    ),

                    const SizedBox(height: 30),

                    /// STRUCTURE
                    sectionTitle("Structure Details"),

                    TextFormField(
                      controller: floorsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Floors",
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: columnSpacingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Column Spacing (m)",
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
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// MATERIAL
                    sectionTitle("Materials"),

                    DropdownButtonFormField(
                      value: concreteGrade,
                      items: const [
                        DropdownMenuItem(value: "M20", child: Text("M20")),
                        DropdownMenuItem(value: "M25", child: Text("M25")),
                        DropdownMenuItem(value: "M30", child: Text("M30")),
                      ],
                      onChanged: (v) => concreteGrade = v.toString(),
                      decoration: const InputDecoration(
                        labelText: "Concrete Grade",
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField(
                      value: steelGrade,
                      items: const [
                        DropdownMenuItem(value: "Fe415", child: Text("Fe415")),
                        DropdownMenuItem(value: "Fe500", child: Text("Fe500")),
                        DropdownMenuItem(value: "Fe550", child: Text("Fe550")),
                      ],
                      onChanged: (v) => steelGrade = v.toString(),
                      decoration: const InputDecoration(
                        labelText: "Steel Grade",
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// UTILITIES
                    sectionTitle("Utilities"),

                    CheckboxListTile(
                      value: waterSupply,
                      title: const Text("Water Supply"),
                      onChanged: (v) => setState(() => waterSupply = v!),
                    ),

                    CheckboxListTile(
                      value: sewerSystem,
                      title: const Text("Sewer System"),
                      onChanged: (v) => setState(() => sewerSystem = v!),
                    ),

                    CheckboxListTile(
                      value: electricalLayout,
                      title: const Text("Electrical Layout"),
                      onChanged: (v) => setState(() => electricalLayout = v!),
                    ),

                    CheckboxListTile(
                      value: hvacSystem,
                      title: const Text("HVAC System"),
                      onChanged: (v) => setState(() => hvacSystem = v!),
                    ),

                    const SizedBox(height: 30),

                    /// INDUSTRIAL
                    sectionTitle("Industrial Equipment"),

                    TextFormField(
                      controller: tanksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Tanks",
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: pumpsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Pumps",
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: pipeDiameterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Pipe Diameter (mm)",
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// ENGINEER NOTES
                    /// =========================
                    sectionTitle("Engineer Notes / Special Instructions"),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Custom Description (Optional)",
                        hintText:
                            "Example:\nProvide parking area in front.\nPlace staircase on west side.\nAdd two water tanks.",
                        prefixIcon: Icon(Icons.notes),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

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
