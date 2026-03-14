import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FenceInputScreen extends StatefulWidget {
  const FenceInputScreen({super.key});

  @override
  State<FenceInputScreen> createState() => _FenceInputScreenState();
}

class _FenceInputScreenState extends State<FenceInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// BOUNDARY
  final boundaryLengthController = TextEditingController();
  final fenceHeightController = TextEditingController();

  /// FENCE TYPE
  String fenceType = "Chain Link";
  final postSpacingController = TextEditingController();

  /// STRUCTURAL
  final postDiameterController = TextEditingController();
  final postDepthController = TextEditingController();
  final concreteGradeController = TextEditingController();

  /// GATE
  final gateCountController = TextEditingController();
  final gateWidthController = TextEditingController();
  String gateType = "Sliding";

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A2";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Fence / Boundary Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project"),

              Text("Project: ${project?.name ?? "Unnamed"}"),

              field(projectNameController, "Project Name"),
              field(locationController, "Location"),

              const SizedBox(height: 20),

              /// BOUNDARY
              sectionTitle("Boundary Geometry"),

              field(boundaryLengthController, "Boundary Length (m)"),
              field(fenceHeightController, "Fence Height (m)"),

              const SizedBox(height: 20),

              /// FENCE TYPE
              sectionTitle("Fence Type"),

              dropdown("Fence Type", fenceType, [
                "Chain Link",
                "Barbed Wire",
                "Steel Panel",
                "Concrete Wall",
              ], (v) => setState(() => fenceType = v!)),

              field(postSpacingController, "Post Spacing (m)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),

              field(postDiameterController, "Post Diameter (mm)"),
              field(postDepthController, "Post Depth (m)"),
              field(concreteGradeController, "Concrete Grade"),

              const SizedBox(height: 20),

              /// GATE
              sectionTitle("Gate Details"),

              field(gateCountController, "Number of Gates"),
              field(gateWidthController, "Gate Width (m)"),

              dropdown("Gate Type", gateType, [
                "Sliding",
                "Hinged",
              ], (v) => setState(() => gateType = v!)),

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
                  child: const Text("Generate Fence Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "boundary": {
                        "length": boundaryLengthController.text,
                        "height": fenceHeightController.text,
                      },

                      "fence": {
                        "type": fenceType,
                        "postSpacing": postSpacingController.text,
                      },

                      "structure": {
                        "postDiameter": postDiameterController.text,
                        "postDepth": postDepthController.text,
                        "concreteGrade": concreteGradeController.text,
                      },

                      "gate": {
                        "count": gateCountController.text,
                        "width": gateWidthController.text,
                        "type": gateType,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "fence",
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
