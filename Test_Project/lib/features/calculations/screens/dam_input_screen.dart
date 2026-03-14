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
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];

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

              field(damNameController, "Dam Name"),
              field(riverController, "River Name"),
              field(locationController, "Location"),

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

              field(concreteGradeController, "Concrete Grade"),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),
              field(seismicZoneController, "Seismic Zone"),
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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Dam Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
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

                    controller.generateDrawingFromInputs(
                      type: "dam",
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
