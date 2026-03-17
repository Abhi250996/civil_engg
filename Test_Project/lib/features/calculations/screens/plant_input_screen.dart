import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class PlantInputScreen extends StatefulWidget {
  const PlantInputScreen({super.key});

  @override
  State<PlantInputScreen> createState() => _PlantInputScreenState();
}

class _PlantInputScreenState extends State<PlantInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// PROJECT
  final plantNameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();

  /// SITE
  final siteLengthController = TextEditingController();
  final siteWidthController = TextEditingController();
  String orientation = "North";

  /// LAYOUT
  final productionAreaController = TextEditingController();
  final utilityAreaController = TextEditingController();
  final storageAreaController = TextEditingController();
  final controlRoomController = TextEditingController();

  /// EQUIPMENT
  final equipmentCountController = TextEditingController();
  final equipmentSpacingController = TextEditingController();
  final craneCapacityController = TextEditingController();

  /// STRUCTURE
  final buildingHeightController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final floorLoadController = TextEditingController();
  String materialType = "Steel";

  /// UTILITIES
  final pipelineWidthController = TextEditingController();
  final internalRoadController = TextEditingController();
  final serviceRoadsController = TextEditingController();

  /// DRAWING
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Industrial Plant Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Project"),
              Text("Project: ${project?.name ?? "Unnamed"}"),

              field(plantNameController, "Plant Name", isNumber: false),
              field(industryController, "Industry Type", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// SITE
              sectionTitle("Site Geometry"),
              field(siteLengthController, "Site Length (m)"),
              field(siteWidthController, "Site Width (m)"),

              dropdown("Orientation", orientation, [
                "North",
                "South",
                "East",
                "West",
              ], (v) => setState(() => orientation = v!)),

              const SizedBox(height: 20),

              /// LAYOUT
              sectionTitle("Plant Layout"),
              field(productionAreaController, "Production Area (m²)"),
              field(utilityAreaController, "Utility Area (m²)"),
              field(storageAreaController, "Storage Area (m²)"),
              field(controlRoomController, "Control Room Area (m²)"),

              const SizedBox(height: 20),

              /// EQUIPMENT
              sectionTitle("Equipment"),
              field(equipmentCountController, "Number of Equipment"),
              field(equipmentSpacingController, "Equipment Spacing (m)"),
              field(craneCapacityController, "Crane Capacity (tons)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),
              field(buildingHeightController, "Building Height (m)"),
              field(columnSpacingController, "Column Spacing (m)"),
              field(floorLoadController, "Floor Load Capacity (kN/m²)"),

              dropdown(
                "Material Type",
                materialType,
                ["Steel", "Concrete"],
                (v) => setState(() => materialType = v!),
              ),

              const SizedBox(height: 20),

              /// UTILITIES
              sectionTitle("Utilities"),
              field(pipelineWidthController, "Pipeline Corridor Width (m)"),
              field(internalRoadController, "Internal Road Width (m)"),
              field(serviceRoadsController, "Number of Service Roads"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),
              dropdown("Scale", scale, [
                "1:100",
                "1:200",
                "1:500",
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
                              "name": plantNameController.text,
                              "industry": industryController.text,
                              "location": locationController.text,
                            },
                            "site": {
                              "length": siteLengthController.text,
                              "width": siteWidthController.text,
                              "orientation": orientation,
                            },
                            "layout": {
                              "productionArea": productionAreaController.text,
                              "utilityArea": utilityAreaController.text,
                              "storageArea": storageAreaController.text,
                              "controlRoom": controlRoomController.text,
                            },
                            "equipment": {
                              "count": equipmentCountController.text,
                              "spacing": equipmentSpacingController.text,
                              "craneCapacity": craneCapacityController.text,
                            },
                            "structure": {
                              "height": buildingHeightController.text,
                              "columnSpacing": columnSpacingController.text,
                              "floorLoad": floorLoadController.text,
                              "material": materialType,
                            },
                            "utilities": {
                              "pipelineWidth": pipelineWidthController.text,
                              "internalRoad": internalRoadController.text,
                              "serviceRoads": serviceRoadsController.text,
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
                                  type: "plant",
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
                              );
                            } else {
                              Get.snackbar(
                                "Error",
                                response["message"] ?? "Something went wrong",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);

                            Get.snackbar(
                              "Error",
                              e.toString(),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
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
                      : const Text("Generate Plant Layout"),
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
