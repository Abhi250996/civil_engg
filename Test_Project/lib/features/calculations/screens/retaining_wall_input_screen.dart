import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class RetainingWallInputScreen extends StatefulWidget {
  const RetainingWallInputScreen({super.key});

  @override
  State<RetainingWallInputScreen> createState() =>
      _RetainingWallInputScreenState();
}

class _RetainingWallInputScreenState extends State<RetainingWallInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// GEOMETRY
  final heightController = TextEditingController();
  final lengthController = TextEditingController();
  final baseWidthController = TextEditingController();
  final stemThicknessController = TextEditingController();

  /// WALL TYPE
  String wallType = "Cantilever Wall";

  /// SOIL
  final soilWeightController = TextEditingController();
  final frictionController = TextEditingController();
  final soilBearingController = TextEditingController();

  /// DRAINAGE
  String drainType = "Weep Holes";
  final drainSpacingController = TextEditingController();
  final filterThicknessController = TextEditingController();

  /// STRUCTURAL
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();
  final seismicZoneController = TextEditingController();

  /// DRAWING
  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Retaining Wall Design")),

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

              field(projectNameController, "Project Name"),
              field(locationController, "Location"),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Wall Geometry"),

              field(heightController, "Wall Height (m)"),
              field(lengthController, "Wall Length (m)"),
              field(baseWidthController, "Base Width (m)"),
              field(stemThicknessController, "Stem Thickness (mm)"),

              const SizedBox(height: 20),

              /// WALL TYPE
              sectionTitle("Wall Type"),

              dropdown("Retaining Wall Type", wallType, [
                "Cantilever Wall",
                "Gravity Wall",
                "Counterfort Wall",
                "Gabion Wall",
              ], (v) => setState(() => wallType = v!)),

              const SizedBox(height: 20),

              /// SOIL
              sectionTitle("Soil Parameters"),

              field(soilWeightController, "Soil Unit Weight (kN/m³)"),
              field(frictionController, "Soil Friction Angle (°)"),
              field(soilBearingController, "Soil Bearing Capacity (kN/m²)"),

              const SizedBox(height: 20),

              /// DRAINAGE
              sectionTitle("Drainage"),

              dropdown("Drain Type", drainType, [
                "Weep Holes",
                "Drain Pipe",
              ], (v) => setState(() => drainType = v!)),

              field(drainSpacingController, "Drain Spacing (m)"),
              field(filterThicknessController, "Filter Layer Thickness (mm)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),

              field(concreteGradeController, "Concrete Grade"),
              field(steelGradeController, "Steel Grade"),
              field(seismicZoneController, "Seismic Zone"),

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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Retaining Wall Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "geometry": {
                        "height": heightController.text,
                        "length": lengthController.text,
                        "baseWidth": baseWidthController.text,
                        "stemThickness": stemThicknessController.text,
                      },

                      "wall": {"type": wallType},

                      "soil": {
                        "unitWeight": soilWeightController.text,
                        "frictionAngle": frictionController.text,
                        "bearingCapacity": soilBearingController.text,
                      },

                      "drainage": {
                        "type": drainType,
                        "spacing": drainSpacingController.text,
                        "filterThickness": filterThicknessController.text,
                      },

                      "structure": {
                        "concreteGrade": concreteGradeController.text,
                        "steelGrade": steelGradeController.text,
                        "seismicZone": seismicZoneController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "retaining_wall",
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
