import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class SiloInputScreen extends StatefulWidget {
  const SiloInputScreen({super.key});

  @override
  State<SiloInputScreen> createState() => _SiloInputScreenState();
}

class _SiloInputScreenState extends State<SiloInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// PROJECT
  final siloNameController = TextEditingController();
  final locationController = TextEditingController();

  /// GEOMETRY
  final heightController = TextEditingController();
  final diameterController = TextEditingController();
  final thicknessController = TextEditingController();
  final hopperAngleController = TextEditingController();

  /// STORAGE
  String material = "Grain";
  final capacityController = TextEditingController();
  final densityController = TextEditingController();

  /// STRUCTURAL
  String structureType = "Concrete";
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();
  final windLoadController = TextEditingController();

  /// FOUNDATION
  String foundationType = "Raft";
  final foundationDiameterController = TextEditingController();
  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  void dispose() {
    siloNameController.dispose();
    locationController.dispose();
    heightController.dispose();
    diameterController.dispose();
    thicknessController.dispose();
    hopperAngleController.dispose();
    capacityController.dispose();
    densityController.dispose();
    concreteGradeController.dispose();
    steelGradeController.dispose();
    windLoadController.dispose();
    foundationDiameterController.dispose();
    foundationDepthController.dispose();
    soilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Silo Design")),

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

              field(siloNameController, "Silo Name", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Silo Geometry"),
              field(heightController, "Silo Height (m)"),
              field(diameterController, "Silo Diameter (m)"),
              field(thicknessController, "Wall Thickness (mm)"),
              field(hopperAngleController, "Hopper Angle (°)"),

              const SizedBox(height: 20),

              /// STORAGE
              sectionTitle("Storage Parameters"),
              dropdown("Stored Material", material, [
                "Grain",
                "Cement",
                "Coal",
                "Sand",
              ], (v) => setState(() => material = v!)),

              field(capacityController, "Storage Capacity (tons)"),
              field(densityController, "Bulk Density (kg/m³)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),
              dropdown(
                "Structure Type",
                structureType,
                ["Concrete", "Steel"],
                (v) => setState(() => structureType = v!),
              ),

              field(concreteGradeController, "Concrete Grade"),
              field(steelGradeController, "Steel Grade"),
              field(windLoadController, "Wind Load (kN/m²)"),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation"),
              dropdown(
                "Foundation Type",
                foundationType,
                ["Raft", "Circular Footing", "Pile"],
                (v) => setState(() => foundationType = v!),
              ),

              field(foundationDiameterController, "Foundation Diameter (m)"),
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

                          final data = {
                            "project": {
                              "name": siloNameController.text,
                              "location": locationController.text,
                            },
                            "geometry": {
                              "height": heightController.text,
                              "diameter": diameterController.text,
                              "thickness": thicknessController.text,
                              "hopperAngle": hopperAngleController.text,
                            },
                            "storage": {
                              "material": material,
                              "capacity": capacityController.text,
                              "density": densityController.text,
                            },
                            "structure": {
                              "type": structureType,
                              "concreteGrade": concreteGradeController.text,
                              "steelGrade": steelGradeController.text,
                              "windLoad": windLoadController.text,
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
                            final res = await controller
                                .generateDrawingFromInputs(
                                  type: "silo",
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
                      : const Text("Generate Silo Drawing"),
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
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
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
}
