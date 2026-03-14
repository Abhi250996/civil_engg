import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class PipelineInputScreen extends StatefulWidget {
  const PipelineInputScreen({super.key});

  @override
  State<PipelineInputScreen> createState() => _PipelineInputScreenState();
}

class _PipelineInputScreenState extends State<PipelineInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// PIPELINE
  final lengthController = TextEditingController();
  final diameterController = TextEditingController();
  final thicknessController = TextEditingController();

  /// HYDRAULICS
  final flowRateController = TextEditingController();
  final pressureController = TextEditingController();

  /// ROUTE
  final startElevationController = TextEditingController();
  final endElevationController = TextEditingController();

  /// COMPONENTS
  final valveSpacingController = TextEditingController();
  final pumpStationsController = TextEditingController();
  final supportSpacingController = TextEditingController();

  String fluidType = "Water";
  String groundType = "Soil";

  String scale = "1:500";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pipeline Design")),

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

              /// PIPELINE GEOMETRY
              sectionTitle("Pipeline Geometry"),

              field(lengthController, "Pipeline Length (km)"),
              field(diameterController, "Pipe Diameter (mm)"),
              field(thicknessController, "Wall Thickness (mm)"),

              const SizedBox(height: 20),

              /// HYDRAULICS
              sectionTitle("Hydraulic Parameters"),

              field(flowRateController, "Flow Rate (m³/s)"),
              field(pressureController, "Pressure (bar)"),

              dropdown("Fluid Type", fluidType, [
                "Water",
                "Oil",
                "Gas",
                "Chemical",
              ], (v) => setState(() => fluidType = v!)),

              const SizedBox(height: 20),

              /// ROUTE
              sectionTitle("Route Parameters"),

              field(startElevationController, "Start Elevation (m)"),
              field(endElevationController, "End Elevation (m)"),

              dropdown("Ground Type", groundType, [
                "Soil",
                "Rock",
                "Mixed",
              ], (v) => setState(() => groundType = v!)),

              const SizedBox(height: 20),

              /// COMPONENTS
              sectionTitle("Pipeline Components"),

              field(valveSpacingController, "Valve Spacing (m)"),
              field(pumpStationsController, "Number of Pump Stations"),
              field(supportSpacingController, "Support Spacing (m)"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),

              dropdown("Scale", scale, [
                "1:200",
                "1:500",
                "1:1000",
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
                  child: const Text("Generate Pipeline Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "pipeline": {
                        "length": lengthController.text,
                        "diameter": diameterController.text,
                        "thickness": thicknessController.text,
                      },

                      "hydraulics": {
                        "flowRate": flowRateController.text,
                        "pressure": pressureController.text,
                        "fluid": fluidType,
                      },

                      "route": {
                        "startElevation": startElevationController.text,
                        "endElevation": endElevationController.text,
                        "ground": groundType,
                      },

                      "components": {
                        "valveSpacing": valveSpacingController.text,
                        "pumpStations": pumpStationsController.text,
                        "supportSpacing": supportSpacingController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "pipeline",
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
