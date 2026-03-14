import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TunnelInputScreen extends StatefulWidget {
  const TunnelInputScreen({super.key});

  @override
  State<TunnelInputScreen> createState() => _TunnelInputScreenState();
}

class _TunnelInputScreenState extends State<TunnelInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// GEOMETRY
  final lengthController = TextEditingController();
  final diameterController = TextEditingController();
  final depthController = TextEditingController();

  /// GEOTECHNICAL
  final rockStrengthController = TextEditingController();
  final groundwaterController = TextEditingController();

  /// STRUCTURE
  final liningThicknessController = TextEditingController();
  final rebarDiameterController = TextEditingController();

  /// SYSTEMS
  final ventilationDiameterController = TextEditingController();
  final drainageWidthController = TextEditingController();

  String tunnelType = "Road Tunnel";
  String rockType = "Hard Rock";
  String excavationMethod = "TBM";

  String concreteGrade = "M30";

  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Tunnel Design")),

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

              /// GEOMETRY
              sectionTitle("Tunnel Geometry"),

              field(lengthController, "Tunnel Length (m)"),
              field(diameterController, "Tunnel Diameter (m)"),
              field(depthController, "Tunnel Depth (m)"),

              dropdown("Tunnel Type", tunnelType, [
                "Road Tunnel",
                "Railway Tunnel",
                "Metro Tunnel",
                "Utility Tunnel",
              ], (v) => setState(() => tunnelType = v!)),

              const SizedBox(height: 20),

              /// GEOTECHNICAL
              sectionTitle("Geotechnical Parameters"),

              dropdown("Rock Type", rockType, [
                "Soft Rock",
                "Hard Rock",
                "Soil",
              ], (v) => setState(() => rockType = v!)),

              field(rockStrengthController, "Rock Strength (MPa)"),
              field(groundwaterController, "Groundwater Level (m)"),

              const SizedBox(height: 20),

              /// EXCAVATION
              sectionTitle("Excavation Method"),

              dropdown(
                "Method",
                excavationMethod,
                ["TBM", "NATM", "Drill & Blast"],
                (v) => setState(() => excavationMethod = v!),
              ),

              const SizedBox(height: 20),

              /// STRUCTURE
              sectionTitle("Structural Lining"),

              field(liningThicknessController, "Lining Thickness (mm)"),

              dropdown(
                "Concrete Grade",
                concreteGrade,
                ["M25", "M30", "M35"],
                (v) => setState(() => concreteGrade = v!),
              ),

              field(rebarDiameterController, "Rebar Diameter (mm)"),

              const SizedBox(height: 20),

              /// SYSTEMS
              sectionTitle("Ventilation & Drainage"),

              field(
                ventilationDiameterController,
                "Ventilation Shaft Diameter (m)",
              ),
              field(drainageWidthController, "Drainage Channel Width (mm)"),

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
                  child: const Text("Generate Tunnel Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "geometry": {
                        "length": lengthController.text,
                        "diameter": diameterController.text,
                        "depth": depthController.text,
                        "type": tunnelType,
                      },

                      "geotechnical": {
                        "rockType": rockType,
                        "rockStrength": rockStrengthController.text,
                        "groundwater": groundwaterController.text,
                      },

                      "excavation": {"method": excavationMethod},

                      "structure": {
                        "liningThickness": liningThicknessController.text,
                        "concreteGrade": concreteGrade,
                        "rebarDiameter": rebarDiameterController.text,
                      },

                      "systems": {
                        "ventilationDiameter":
                            ventilationDiameterController.text,
                        "drainageWidth": drainageWidthController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "tunnel",
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
