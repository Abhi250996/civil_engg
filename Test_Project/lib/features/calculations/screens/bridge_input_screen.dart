import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class BridgeInputScreen extends StatefulWidget {
  const BridgeInputScreen({super.key});

  @override
  State<BridgeInputScreen> createState() => _BridgeInputScreenState();
}

class _BridgeInputScreenState extends State<BridgeInputScreen> {
  final CalculationController controller = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final spansController = TextEditingController();
  final spanLengthController = TextEditingController();
  final pierSpacingController = TextEditingController();
  final clearanceController = TextEditingController();

  final designLoadController = TextEditingController();
  final soilController = TextEditingController();
  final foundationDepthController = TextEditingController();

  final riverWidthController = TextEditingController();
  final floodLevelController = TextEditingController();

  String bridgeType = "Beam Bridge";
  String material = "Reinforced Concrete";
  String foundationType = "Pile Foundation";

  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Bridge Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// PROJECT
              sectionTitle("Project Information"),

              Text("Project: ${project?.name ?? "Unnamed"}"),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Bridge Geometry"),

              field(lengthController, "Bridge Length (m)"),
              field(widthController, "Deck Width (m)"),
              field(spansController, "Number of Spans"),
              field(spanLengthController, "Span Length (m)"),
              field(pierSpacingController, "Pier Spacing (m)"),
              field(clearanceController, "Clearance Height (m)"),

              const SizedBox(height: 20),

              /// STRUCTURE
              sectionTitle("Structural Design"),

              dropdown("Bridge Type", bridgeType, [
                "Beam Bridge",
                "Arch Bridge",
                "Suspension Bridge",
                "Cable Stayed Bridge",
              ], (v) => setState(() => bridgeType = v!)),

              dropdown("Material", material, [
                "Reinforced Concrete",
                "Steel",
                "Composite",
              ], (v) => setState(() => material = v!)),

              field(designLoadController, "Design Load (kN)"),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation"),

              dropdown(
                "Foundation Type",
                foundationType,
                ["Pile Foundation", "Open Foundation", "Well Foundation"],
                (v) => setState(() => foundationType = v!),
              ),

              field(foundationDepthController, "Foundation Depth (m)"),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),

              const SizedBox(height: 20),

              /// ENVIRONMENT
              sectionTitle("Environmental Conditions"),

              field(riverWidthController, "River Width (m)"),
              field(floodLevelController, "Flood Level (m)"),

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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Bridge Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "geometry": {
                        "length": lengthController.text,
                        "width": widthController.text,
                        "spans": spansController.text,
                        "spanLength": spanLengthController.text,
                        "pierSpacing": pierSpacingController.text,
                        "clearance": clearanceController.text,
                      },

                      "structure": {
                        "bridgeType": bridgeType,
                        "material": material,
                        "designLoad": designLoadController.text,
                      },

                      "foundation": {
                        "type": foundationType,
                        "depth": foundationDepthController.text,
                        "soilBearingCapacity": soilController.text,
                      },

                      "environment": {
                        "riverWidth": riverWidthController.text,
                        "floodLevel": floodLevelController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "bridge",
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
