import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FoundationInputScreen extends StatefulWidget {
  const FoundationInputScreen({super.key});

  @override
  State<FoundationInputScreen> createState() => _FoundationInputScreenState();
}

class _FoundationInputScreenState extends State<FoundationInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// STRUCTURE
  final floorsController = TextEditingController();
  final columnLoadController = TextEditingController();

  String structureType = "Building";

  /// SOIL
  final soilBearingController = TextEditingController();
  final waterTableController = TextEditingController();

  String soilType = "Clay";

  /// FOUNDATION
  final footingLengthController = TextEditingController();
  final footingWidthController = TextEditingController();
  final footingThicknessController = TextEditingController();

  /// COLUMN
  final columnSizeController = TextEditingController();
  final columnSpacingController = TextEditingController();

  /// REINFORCEMENT
  final rebarDiameterController = TextEditingController();
  final rebarSpacingController = TextEditingController();

  /// DRAWING
  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foundation Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project Information"),

              field(projectNameController, "Project Name"),
              field(locationController, "Location"),

              const SizedBox(height: 20),

              /// STRUCTURE
              sectionTitle("Structure Information"),

              dropdown(
                "Structure Type",
                structureType,
                ["Building", "Tower", "Bridge", "Industrial"],
                (v) => setState(() => structureType = v!),
              ),

              field(floorsController, "Number of Floors"),
              field(columnLoadController, "Column Load (kN)"),

              const SizedBox(height: 20),

              /// SOIL
              sectionTitle("Soil Parameters"),

              field(soilBearingController, "Soil Bearing Capacity (kN/m²)"),
              field(waterTableController, "Water Table Depth (m)"),

              dropdown("Soil Type", soilType, [
                "Clay",
                "Sand",
                "Rock",
                "Mixed",
              ], (v) => setState(() => soilType = v!)),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation Geometry"),

              field(footingLengthController, "Footing Length (m)"),
              field(footingWidthController, "Footing Width (m)"),
              field(footingThicknessController, "Footing Thickness (m)"),

              const SizedBox(height: 20),

              /// COLUMN
              sectionTitle("Column Parameters"),

              field(columnSizeController, "Column Size (mm)"),
              field(columnSpacingController, "Column Spacing (m)"),

              const SizedBox(height: 20),

              /// REINFORCEMENT
              sectionTitle("Reinforcement"),

              field(rebarDiameterController, "Rebar Diameter (mm)"),
              field(rebarSpacingController, "Rebar Spacing (mm)"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),

              dropdown("Scale", scale, [
                "1:20",
                "1:50",
                "1:100",
              ], (v) => setState(() => scale = v!)),

              dropdown("Sheet Size", sheetSize, [
                "A0",
                "A1",
                "A2",
                "A3",
              ], (v) => setState(() => sheetSize = v!)),

              dropdown("Detail Level", detailLevel, [
                "Concept",
                "Standard",
                "Construction",
              ], (v) => setState(() => detailLevel = v!)),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Foundation Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "structure": {
                        "type": structureType,
                        "floors": floorsController.text,
                        "columnLoad": columnLoadController.text,
                      },

                      "soil": {
                        "bearingCapacity": soilBearingController.text,
                        "waterTable": waterTableController.text,
                        "type": soilType,
                      },

                      "foundation": {
                        "length": footingLengthController.text,
                        "width": footingWidthController.text,
                        "thickness": footingThicknessController.text,
                      },

                      "column": {
                        "size": columnSizeController.text,
                        "spacing": columnSpacingController.text,
                      },

                      "reinforcement": {
                        "diameter": rebarDiameterController.text,
                        "spacing": rebarSpacingController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "foundation",
                      inputData: data,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        validator: (v) => v!.isEmpty ? "Required" : null,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget dropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
