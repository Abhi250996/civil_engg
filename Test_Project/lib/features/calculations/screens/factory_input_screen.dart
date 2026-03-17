import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FactoryInputScreen extends StatefulWidget {
  const FactoryInputScreen({super.key});

  @override
  State<FactoryInputScreen> createState() => _FactoryInputScreenState();
}

class _FactoryInputScreenState extends State<FactoryInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// PROJECT
  final factoryNameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();

  /// SITE
  final plotLengthController = TextEditingController();
  final plotWidthController = TextEditingController();
  String orientation = "North";

  /// FACTORY LAYOUT
  final productionAreaController = TextEditingController();
  final productionLinesController = TextEditingController();
  final machineSpacingController = TextEditingController();
  final storageAreaController = TextEditingController();
  final officeAreaController = TextEditingController();

  /// STRUCTURAL
  final buildingHeightController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final floorLoadController = TextEditingController();

  String roofType = "Steel Truss";

  /// LOGISTICS
  final loadingDocksController = TextEditingController();
  final truckAccessController = TextEditingController();
  final internalRoadController = TextEditingController();

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Factory Layout Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROJECT
              sectionTitle("Project"),
              Text("Project: ${project?.name ?? "Unnamed"}"),

              field(factoryNameController, "Factory Name", isNumber: false),
              field(industryController, "Industry Type", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// SITE
              sectionTitle("Site Geometry"),
              field(plotLengthController, "Plot Length (m)"),
              field(plotWidthController, "Plot Width (m)"),

              dropdown("Orientation", orientation, [
                "North",
                "South",
                "East",
                "West",
              ], (v) => setState(() => orientation = v!)),

              const SizedBox(height: 20),

              /// FACTORY LAYOUT
              sectionTitle("Factory Layout"),
              field(productionAreaController, "Production Area (m²)"),
              field(productionLinesController, "Number of Production Lines"),
              field(machineSpacingController, "Machine Spacing (m)"),
              field(storageAreaController, "Storage Area (m²)"),
              field(officeAreaController, "Office Area (m²)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),
              field(buildingHeightController, "Building Height (m)"),
              field(columnSpacingController, "Column Spacing (m)"),

              dropdown("Roof Type", roofType, [
                "Steel Truss",
                "RC Slab",
              ], (v) => setState(() => roofType = v!)),

              field(floorLoadController, "Floor Load Capacity (kN/m²)"),

              const SizedBox(height: 20),

              /// LOGISTICS
              sectionTitle("Logistics"),
              field(loadingDocksController, "Number of Loading Docks"),
              field(truckAccessController, "Truck Access Width (m)"),
              field(internalRoadController, "Internal Road Width (m)"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),
              dropdown("Scale", scale, [
                "1:50",
                "1:100",
                "1:200",
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
                              "factoryName": factoryNameController.text,
                              "industry": industryController.text,
                              "location": locationController.text,
                            },
                            "site": {
                              "length": plotLengthController.text,
                              "width": plotWidthController.text,
                              "orientation": orientation,
                            },
                            "layout": {
                              "productionArea": productionAreaController.text,
                              "productionLines": productionLinesController.text,
                              "machineSpacing": machineSpacingController.text,
                              "storageArea": storageAreaController.text,
                              "officeArea": officeAreaController.text,
                            },
                            "structure": {
                              "height": buildingHeightController.text,
                              "columnSpacing": columnSpacingController.text,
                              "roofType": roofType,
                              "floorLoad": floorLoadController.text,
                            },
                            "logistics": {
                              "loadingDocks": loadingDocksController.text,
                              "truckAccess": truckAccessController.text,
                              "internalRoad": internalRoadController.text,
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
                                  type: "factory",
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
                      : const Text("Generate Factory Layout"),
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
