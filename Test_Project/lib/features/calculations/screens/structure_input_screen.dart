import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../../../core/constants/route_constants.dart';
import '../controllers/calculation_controller.dart';

class StructureInputScreen extends StatefulWidget {
  const StructureInputScreen({super.key});

  @override
  State<StructureInputScreen> createState() => _StructureInputScreenState();
}

class _StructureInputScreenState extends State<StructureInputScreen> {
  final CalculationController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final args = Get.arguments ?? {};

  late final String structureType;

  @override
  void initState() {
    super.initState();
    structureType = (args["type"] ?? "building").toString();
  }

  /// =========================
  /// PROJECT
  /// =========================

  final projectNameController = TextEditingController();

  String unitSystem = "Metric";
  String drawingScale = "1:100";
  String northDirection = "North";

  /// =========================
  /// SITE
  /// =========================

  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  String soilType = "Clay";

  /// =========================
  /// STRUCTURE
  /// =========================

  final floorsController = TextEditingController();
  final columnSpacingController = TextEditingController();

  String structureSystem = "RCC";
  String foundationType = "Isolated Footing";

  /// =========================
  /// MATERIAL
  /// =========================

  String concreteGrade = "M25";
  String steelGrade = "Fe500";

  /// =========================
  /// ROAD
  /// =========================

  final roadWidthController = TextEditingController();
  final drainSlopeController = TextEditingController();

  /// =========================
  /// INDUSTRIAL
  /// =========================

  final tanksController = TextEditingController();
  final pumpsController = TextEditingController();
  final pipeDiameterController = TextEditingController();

  /// =========================
  /// UTILITIES
  /// =========================

  bool waterSupply = true;
  bool sewerSystem = true;
  bool electricalLayout = true;
  bool hvacSystem = false;

  /// =========================
  /// NOTES
  /// =========================

  final descriptionController = TextEditingController();

  /// =========================
  /// GENERATE DRAWING
  /// =========================

  void generateDrawing() {
    if (!_formKey.currentState!.validate()) return;

    String prompt =
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
""";

    /// STRUCTURE

    if (structureType == "building" ||
        structureType == "plant" ||
        structureType == "factory") {
      prompt +=
          """

Structure:
Floors: ${floorsController.text}
Column spacing: ${columnSpacingController.text}
Structure system: $structureSystem
Foundation: $foundationType
""";
    }

    /// ROAD

    if (structureType == "road") {
      prompt +=
          """

Road Design:
Road width: ${roadWidthController.text}
Drain slope: ${drainSlopeController.text}
""";
    }

    /// INDUSTRIAL

    if (structureType == "plant" || structureType == "factory") {
      prompt +=
          """

Industrial Equipment:
Tanks: ${tanksController.text}
Pumps: ${pumpsController.text}
Pipe diameter: ${pipeDiameterController.text}
""";
    }

    /// MATERIAL

    if (structureType != "road") {
      prompt +=
          """

Materials:
Concrete: $concreteGrade
Steel: $steelGrade
""";
    }

    /// UTILITIES

    prompt +=
        """

Utilities:
Water supply: $waterSupply
Sewer system: $sewerSystem
Electrical: $electricalLayout
HVAC: $hvacSystem
""";

    if (descriptionController.text.isNotEmpty) {
      prompt +=
          """

Engineer Instructions:
${descriptionController.text}
""";
    }

    controller.generateAIDrawing(prompt);

    Get.toNamed(RouteConstants.drawingResult);
  }

  /// =========================
  /// SECTION TITLE
  /// =========================

  Widget sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// =========================
  /// BUILD
  /// =========================

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
                    /// =========================
                    /// PROJECT
                    /// =========================
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

                    const SizedBox(height: 30),

                    /// =========================
                    /// SITE
                    /// =========================
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

                    /// =========================
                    /// STRUCTURE
                    /// =========================
                    if (structureType == "building" ||
                        structureType == "factory" ||
                        structureType == "plant") ...[
                      const SizedBox(height: 30),

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
                          labelText: "Column Spacing",
                        ),
                      ),
                    ],

                    /// =========================
                    /// ROAD
                    /// =========================
                    if (structureType == "road") ...[
                      const SizedBox(height: 30),

                      sectionTitle("Road Design"),

                      TextFormField(
                        controller: roadWidthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Road Width",
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: drainSlopeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Drain Slope",
                        ),
                      ),
                    ],

                    /// =========================
                    /// INDUSTRIAL
                    /// =========================
                    if (structureType == "plant" ||
                        structureType == "factory") ...[
                      const SizedBox(height: 30),

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
                    ],

                    /// =========================
                    /// UTILITIES
                    /// =========================
                    const SizedBox(height: 30),

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

                    /// =========================
                    /// ENGINEER NOTES
                    /// =========================
                    sectionTitle("Engineer Notes"),

                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Special Instructions",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

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
