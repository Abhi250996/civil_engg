import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TowerInputScreen extends StatefulWidget {
  const TowerInputScreen({super.key});

  @override
  State<TowerInputScreen> createState() => _TowerInputScreenState();
}

class _TowerInputScreenState extends State<TowerInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// GEOMETRY
  final heightController = TextEditingController();
  final baseWidthController = TextEditingController();
  final topWidthController = TextEditingController();

  /// STRUCTURE
  final levelsController = TextEditingController();
  final legDiameterController = TextEditingController();

  /// WIND
  final windSpeedController = TextEditingController();
  final windLoadController = TextEditingController();

  /// FOUNDATION
  final foundationDepthController = TextEditingController();

  String towerType = "Transmission Tower";
  String bracingType = "X Bracing";
  String foundationType = "Pile Foundation";

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  void dispose() {
    projectNameController.dispose();
    locationController.dispose();
    heightController.dispose();
    baseWidthController.dispose();
    topWidthController.dispose();
    levelsController.dispose();
    legDiameterController.dispose();
    windSpeedController.dispose();
    windLoadController.dispose();
    foundationDepthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tower Structure Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project Information"),

              field(projectNameController, "Project Name", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// TOWER TYPE
              sectionTitle("Tower Type"),

              dropdown("Tower Type", towerType, [
                "Transmission Tower",
                "Telecom Tower",
                "Observation Tower",
                "Power Line Tower",
              ], (v) => setState(() => towerType = v!)),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Tower Geometry"),

              field(heightController, "Tower Height (m)"),
              field(baseWidthController, "Base Width (m)"),
              field(topWidthController, "Top Width (m)"),

              const SizedBox(height: 20),

              /// STRUCTURE
              sectionTitle("Structural Frame"),

              field(levelsController, "Number of Levels"),
              field(legDiameterController, "Leg Member Diameter (mm)"),

              dropdown("Bracing Type", bracingType, [
                "X Bracing",
                "K Bracing",
              ], (v) => setState(() => bracingType = v!)),

              const SizedBox(height: 20),

              /// WIND
              sectionTitle("Wind Parameters"),

              field(windSpeedController, "Wind Speed (km/h)"),
              field(windLoadController, "Wind Load (kN/m²)"),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation"),

              dropdown(
                "Foundation Type",
                foundationType,
                ["Pile Foundation", "Raft Foundation", "Isolated Footing"],
                (v) => setState(() => foundationType = v!),
              ),

              field(foundationDepthController, "Foundation Depth (m)"),

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
                              "name": projectNameController.text,
                              "location": locationController.text,
                            },
                            "tower": {
                              "type": towerType,
                              "height": heightController.text,
                              "baseWidth": baseWidthController.text,
                              "topWidth": topWidthController.text,
                            },
                            "structure": {
                              "levels": levelsController.text,
                              "legDiameter": legDiameterController.text,
                              "bracing": bracingType,
                            },
                            "wind": {
                              "speed": windSpeedController.text,
                              "load": windLoadController.text,
                            },
                            "foundation": {
                              "type": foundationType,
                              "depth": foundationDepthController.text,
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
                                  type: "tower",
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
                      : const Text("Generate Tower Drawing"),
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
