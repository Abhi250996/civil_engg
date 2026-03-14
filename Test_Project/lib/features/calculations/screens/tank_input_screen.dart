import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TankInputScreen extends StatefulWidget {
  const TankInputScreen({super.key});

  @override
  State<TankInputScreen> createState() => _TankInputScreenState();
}

class _TankInputScreenState extends State<TankInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// TANK
  final capacityController = TextEditingController();
  final waterDepthController = TextEditingController();

  final diameterController = TextEditingController();
  final heightController = TextEditingController();
  final wallThicknessController = TextEditingController();

  /// STRUCTURE
  final rebarDiameterController = TextEditingController();
  final rebarSpacingController = TextEditingController();

  /// PIPES
  final inletPipeController = TextEditingController();
  final outletPipeController = TextEditingController();
  final overflowPipeController = TextEditingController();
  final drainPipeController = TextEditingController();

  String tankType = "Overhead Tank";
  String concreteGrade = "M25";

  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Water Tank Design")),

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

              /// TANK TYPE
              sectionTitle("Tank Type"),

              dropdown("Tank Type", tankType, [
                "Underground Tank",
                "Overhead Tank",
                "Ground Level Tank",
              ], (v) => setState(() => tankType = v!)),

              const SizedBox(height: 20),

              /// CAPACITY
              sectionTitle("Tank Capacity"),

              field(capacityController, "Tank Capacity (m³)"),
              field(waterDepthController, "Water Depth (m)"),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Tank Geometry"),

              field(diameterController, "Tank Diameter (m)"),
              field(heightController, "Tank Height (m)"),
              field(wallThicknessController, "Wall Thickness (mm)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),

              dropdown(
                "Concrete Grade",
                concreteGrade,
                ["M20", "M25", "M30"],
                (v) => setState(() => concreteGrade = v!),
              ),

              field(rebarDiameterController, "Rebar Diameter (mm)"),
              field(rebarSpacingController, "Rebar Spacing (mm)"),

              const SizedBox(height: 20),

              /// PIPES
              sectionTitle("Pipe Connections"),

              field(inletPipeController, "Inlet Pipe Diameter (mm)"),
              field(outletPipeController, "Outlet Pipe Diameter (mm)"),
              field(overflowPipeController, "Overflow Pipe Diameter (mm)"),
              field(drainPipeController, "Drain Pipe Diameter (mm)"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),

              dropdown("Scale", scale, [
                "1:20",
                "1:50",
                "1:100",
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
                  child: const Text("Generate Tank Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "tank": {
                        "type": tankType,
                        "capacity": capacityController.text,
                        "waterDepth": waterDepthController.text,
                        "diameter": diameterController.text,
                        "height": heightController.text,
                        "wallThickness": wallThicknessController.text,
                      },

                      "structure": {
                        "concreteGrade": concreteGrade,
                        "rebarDiameter": rebarDiameterController.text,
                        "rebarSpacing": rebarSpacingController.text,
                      },

                      "pipes": {
                        "inlet": inletPipeController.text,
                        "outlet": outletPipeController.text,
                        "overflow": overflowPipeController.text,
                        "drain": drainPipeController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "tank",
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
