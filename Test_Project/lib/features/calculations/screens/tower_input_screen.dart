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

  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Construction";

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

              field(projectNameController, "Project Name"),
              field(locationController, "Location"),

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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Tower Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
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

                    controller.generateDrawingFromInputs(
                      type: "tower",
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
