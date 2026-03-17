import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class CustomStructureInputScreen extends StatefulWidget {
  const CustomStructureInputScreen({super.key});

  @override
  State<CustomStructureInputScreen> createState() =>
      _CustomStructureInputScreenState();
}

class _CustomStructureInputScreenState
    extends State<CustomStructureInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// STRUCTURE INFO
  final structureNameController = TextEditingController();
  final descriptionController = TextEditingController();

  /// GEOMETRY
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final levelsController = TextEditingController();

  /// STRUCTURAL LOADS
  final designLoadController = TextEditingController();
  final liveLoadController = TextEditingController();
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();

  /// FOUNDATION
  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  String materialType = "Concrete";
  String foundationType = "Isolated Footing";

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Custom Structure Design")),

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

              const SizedBox(height: 20),

              /// STRUCTURE INFO
              sectionTitle("Structure Information"),
              field(structureNameController, "Structure Name", isNumber: false),
              field(
                descriptionController,
                "Structure Description",
                isNumber: false,
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Geometry"),
              field(lengthController, "Length (m)"),
              field(widthController, "Width (m)"),
              field(heightController, "Height (m)"),
              field(levelsController, "Number of Levels"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),
              dropdown(
                "Material Type",
                materialType,
                ["Concrete", "Steel", "Composite"],
                (v) => setState(() => materialType = v!),
              ),
              field(designLoadController, "Design Load (kN)"),
              field(liveLoadController, "Live Load (kN/m²)"),
              field(windLoadController, "Wind Load (kN/m²)"),
              field(seismicZoneController, "Seismic Zone"),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation"),
              dropdown(
                "Foundation Type",
                foundationType,
                ["Isolated Footing", "Raft", "Pile", "Strip Footing"],
                (v) => setState(() => foundationType = v!),
              ),
              field(foundationDepthController, "Foundation Depth (m)"),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),

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
                            "structure": {
                              "name": structureNameController.text,
                              "description": descriptionController.text,
                              "material": materialType,
                            },
                            "geometry": {
                              "length": lengthController.text,
                              "width": widthController.text,
                              "height": heightController.text,
                              "levels": levelsController.text,
                            },
                            "loads": {
                              "designLoad": designLoadController.text,
                              "liveLoad": liveLoadController.text,
                              "windLoad": windLoadController.text,
                              "seismicZone": seismicZoneController.text,
                            },
                            "foundation": {
                              "type": foundationType,
                              "depth": foundationDepthController.text,
                              "soilBearingCapacity": soilController.text,
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
                                  type: "custom",
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
                      : const Text("Generate Custom Structure Drawing"),
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

  Widget field(
    TextEditingController c,
    String label, {
    bool isNumber = true,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
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
