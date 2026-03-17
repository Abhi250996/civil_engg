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

  /// ================= LOADER =================
  bool isLoading = false;

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
              /// PROJECT
              sectionTitle("Project Information"),
              field(projectNameController, "Project Name", isNumber: false),
              field(locationController, "Location", isNumber: false),

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

              /// ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

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

                          try {
                            final response = await controller
                                .generateDrawingFromInputs(
                                  type: "foundation",
                                  inputData: data,
                                );

                            setState(() => isLoading = false);

                            if (response["success"] == true) {
                              Get.snackbar(
                                "Success",
                                response["message"] ??
                                    "Drawing generated successfully",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                response["message"] ?? "Something went wrong",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);

                            Get.snackbar(
                              "Error",
                              e.toString(),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text("Generate Foundation Drawing"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= COMMON =================

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget field(TextEditingController c, String label, {bool isNumber = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
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
