import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class ChimneyInputScreen extends StatefulWidget {
  const ChimneyInputScreen({super.key});

  @override
  State<ChimneyInputScreen> createState() => _ChimneyInputScreenState();
}

class _ChimneyInputScreenState extends State<ChimneyInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// GEOMETRY
  final heightController = TextEditingController();
  final baseDiameterController = TextEditingController();
  final topDiameterController = TextEditingController();
  final thicknessController = TextEditingController();

  /// STRUCTURAL
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();

  /// THERMAL
  final gasTempController = TextEditingController();
  final gasVelocityController = TextEditingController();
  final liningThicknessController = TextEditingController();

  /// FOUNDATION
  final foundationDepthController = TextEditingController();
  final foundationDiameterController = TextEditingController();
  final soilController = TextEditingController();

  String material = "Reinforced Concrete";
  String foundationType = "Circular Footing";

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Chimney Design")),

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

              /// GEOMETRY
              sectionTitle("Geometry"),
              field(heightController, "Chimney Height (m)"),
              field(baseDiameterController, "Base Diameter (m)"),
              field(topDiameterController, "Top Diameter (m)"),
              field(thicknessController, "Wall Thickness (mm)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),
              dropdown("Material", material, [
                "Reinforced Concrete",
                "Steel",
              ], (v) => setState(() => material = v!)),

              field(windLoadController, "Wind Load (kN/m²)"),
              field(seismicZoneController, "Seismic Zone"),
              field(concreteGradeController, "Concrete Grade"),
              field(steelGradeController, "Steel Grade"),

              const SizedBox(height: 20),

              /// THERMAL
              sectionTitle("Thermal Parameters"),
              field(gasTempController, "Flue Gas Temperature (°C)"),
              field(gasVelocityController, "Gas Velocity (m/s)"),
              field(liningThicknessController, "Lining Thickness (mm)"),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation"),
              dropdown(
                "Foundation Type",
                foundationType,
                ["Circular Footing", "Raft", "Pile Foundation"],
                (v) => setState(() => foundationType = v!),
              ),
              field(foundationDiameterController, "Foundation Diameter (m)"),
              field(foundationDepthController, "Foundation Depth (m)"),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),

              const SizedBox(height: 20),

              /// DRAWING SETTINGS
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
                            "geometry": {
                              "height": heightController.text,
                              "baseDiameter": baseDiameterController.text,
                              "topDiameter": topDiameterController.text,
                              "thickness": thicknessController.text,
                            },
                            "structure": {
                              "material": material,
                              "windLoad": windLoadController.text,
                              "seismicZone": seismicZoneController.text,
                              "concreteGrade": concreteGradeController.text,
                              "steelGrade": steelGradeController.text,
                            },
                            "thermal": {
                              "gasTemp": gasTempController.text,
                              "gasVelocity": gasVelocityController.text,
                              "liningThickness": liningThicknessController.text,
                            },
                            "foundation": {
                              "type": foundationType,
                              "diameter": foundationDiameterController.text,
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
                                  type: "chimney",
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
                      : const Text("Generate Chimney Drawing"),
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
