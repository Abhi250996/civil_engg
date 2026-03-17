import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class DamInputScreen extends StatefulWidget {
  const DamInputScreen({super.key});

  @override
  State<DamInputScreen> createState() => _DamInputScreenState();
}

class _DamInputScreenState extends State<DamInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ✅ LOADER
  bool isLoading = false;

  /// IDENTIFICATION
  final damNameController = TextEditingController();
  final riverController = TextEditingController();
  final locationController = TextEditingController();

  /// GEOMETRY
  final heightController = TextEditingController();
  final crestLengthController = TextEditingController();
  final crestWidthController = TextEditingController();
  final baseWidthController = TextEditingController();

  String damType = "Gravity Dam";

  /// RESERVOIR
  final reservoirCapacityController = TextEditingController();
  final maxWaterLevelController = TextEditingController();
  final minWaterLevelController = TextEditingController();

  /// SPILLWAY
  final spillwayWidthController = TextEditingController();
  final spillwayGatesController = TextEditingController();
  final floodDischargeController = TextEditingController();

  /// STRUCTURAL
  final concreteGradeController = TextEditingController();
  final soilController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final upliftController = TextEditingController();

  /// DRAWING
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  void dispose() {
    damNameController.dispose();
    riverController.dispose();
    locationController.dispose();
    heightController.dispose();
    crestLengthController.dispose();
    crestWidthController.dispose();
    baseWidthController.dispose();
    reservoirCapacityController.dispose();
    maxWaterLevelController.dispose();
    minWaterLevelController.dispose();
    spillwayWidthController.dispose();
    spillwayGatesController.dispose();
    floodDischargeController.dispose();
    concreteGradeController.dispose();
    soilController.dispose();
    seismicZoneController.dispose();
    upliftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments?['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Dam Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Project"),

              Text("Project: ${project?.name ?? "Unnamed"}"),

              field(damNameController, "Dam Name", isNumber: false),
              field(riverController, "River Name", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Dam Geometry"),

              dropdown("Dam Type", damType, [
                "Gravity Dam",
                "Arch Dam",
                "Earthfill Dam",
                "Rockfill Dam",
              ], (v) => setState(() => damType = v!)),

              field(heightController, "Dam Height (m)"),
              field(crestLengthController, "Crest Length (m)"),
              field(crestWidthController, "Crest Width (m)"),
              field(baseWidthController, "Base Width (m)"),

              const SizedBox(height: 20),

              /// RESERVOIR
              sectionTitle("Reservoir Data"),

              field(
                reservoirCapacityController,
                "Reservoir Capacity (million m³)",
              ),
              field(maxWaterLevelController, "Maximum Water Level (m)"),
              field(minWaterLevelController, "Minimum Water Level (m)"),

              const SizedBox(height: 20),

              /// SPILLWAY
              sectionTitle("Spillway"),

              field(spillwayWidthController, "Spillway Width (m)"),
              field(spillwayGatesController, "Number of Gates"),
              field(floodDischargeController, "Design Flood Discharge (m³/s)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),

              field(concreteGradeController, "Concrete Grade", isNumber: false),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),
              field(seismicZoneController, "Seismic Zone", isNumber: false),
              field(upliftController, "Uplift Pressure Factor"),

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

              /// ✅ BUTTON WITH LOADER
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

                          final data = {
                            "project": {
                              "damName": damNameController.text,
                              "river": riverController.text,
                              "location": locationController.text,
                            },
                            "geometry": {
                              "damType": damType,
                              "height": heightController.text,
                              "crestLength": crestLengthController.text,
                              "crestWidth": crestWidthController.text,
                              "baseWidth": baseWidthController.text,
                            },
                            "reservoir": {
                              "capacity": reservoirCapacityController.text,
                              "maxLevel": maxWaterLevelController.text,
                              "minLevel": minWaterLevelController.text,
                            },
                            "spillway": {
                              "width": spillwayWidthController.text,
                              "gates": spillwayGatesController.text,
                              "discharge": floodDischargeController.text,
                            },
                            "structure": {
                              "concreteGrade": concreteGradeController.text,
                              "soilBearingCapacity": soilController.text,
                              "seismicZone": seismicZoneController.text,
                              "uplift": upliftController.text,
                            },
                            "drawing": {
                              "scale": scale,
                              "sheetSize": sheetSize,
                              "detailLevel": detailLevel,
                            },
                          };

                          try {
                            final res = await controller
                                .generateDrawingFromInputs(
                                  type: "dam",
                                  inputData: data,
                                );

                            setState(() => isLoading = false);

                            Get.snackbar(
                              res["success"] == true ? "Success" : "Error",
                              res["message"] ?? "Something went wrong",
                              backgroundColor: res["success"] == true
                                  ? Colors.green
                                  : Colors.red,
                              colorText: Colors.white,
                            );
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
                      : const Text("Generate Dam Drawing"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// COMMON

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget field(TextEditingController c, String label, {bool isNumber = true}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );

  Widget dropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<String>(
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
