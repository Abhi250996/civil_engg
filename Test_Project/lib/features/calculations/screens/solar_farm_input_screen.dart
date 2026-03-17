import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class SolarFarmInputScreen extends StatefulWidget {
  const SolarFarmInputScreen({super.key});

  @override
  State<SolarFarmInputScreen> createState() => _SolarFarmInputScreenState();
}

class _SolarFarmInputScreenState extends State<SolarFarmInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ================= LOADER =================
  bool isLoading = false;

  /// PROJECT
  final farmNameController = TextEditingController();
  final locationController = TextEditingController();

  /// SITE
  final landLengthController = TextEditingController();
  final landWidthController = TextEditingController();
  String terrain = "Flat";

  /// PANEL
  String panelType = "Monocrystalline";
  final panelPowerController = TextEditingController();
  final panelLengthController = TextEditingController();
  final panelWidthController = TextEditingController();

  /// ARRAY
  final tiltController = TextEditingController();
  final rowSpacingController = TextEditingController();
  final panelsPerRowController = TextEditingController();
  final rowsController = TextEditingController();

  /// ELECTRICAL
  final inverterCountController = TextEditingController();
  final transformerController = TextEditingController();
  final trenchWidthController = TextEditingController();

  /// STRUCTURAL
  String mountType = "Fixed Tilt";
  final pileDepthController = TextEditingController();
  final soilController = TextEditingController();

  /// DRAWING
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  void dispose() {
    farmNameController.dispose();
    locationController.dispose();
    landLengthController.dispose();
    landWidthController.dispose();
    panelPowerController.dispose();
    panelLengthController.dispose();
    panelWidthController.dispose();
    tiltController.dispose();
    rowSpacingController.dispose();
    panelsPerRowController.dispose();
    rowsController.dispose();
    inverterCountController.dispose();
    transformerController.dispose();
    trenchWidthController.dispose();
    pileDepthController.dispose();
    soilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Solar Farm Design")),

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

              field(farmNameController, "Solar Farm Name", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// SITE
              sectionTitle("Site Geometry"),
              field(landLengthController, "Land Length (m)"),
              field(landWidthController, "Land Width (m)"),

              dropdown("Terrain Type", terrain, [
                "Flat",
                "Slight Slope",
                "Hill",
              ], (v) => setState(() => terrain = v!)),

              const SizedBox(height: 20),

              /// PANEL
              sectionTitle("Solar Panel"),
              dropdown("Panel Type", panelType, [
                "Monocrystalline",
                "Polycrystalline",
                "Thin Film",
              ], (v) => setState(() => panelType = v!)),

              field(panelPowerController, "Panel Power (W)"),
              field(panelLengthController, "Panel Length (m)"),
              field(panelWidthController, "Panel Width (m)"),

              const SizedBox(height: 20),

              /// ARRAY
              sectionTitle("Array Layout"),
              field(tiltController, "Tilt Angle (°)"),
              field(rowSpacingController, "Row Spacing (m)"),
              field(panelsPerRowController, "Panels per Row"),
              field(rowsController, "Total Rows"),

              const SizedBox(height: 20),

              /// ELECTRICAL
              sectionTitle("Electrical System"),
              field(inverterCountController, "Number of Inverters"),
              field(transformerController, "Transformer Capacity (kVA)"),
              field(trenchWidthController, "Cable Trench Width (m)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Support"),
              dropdown("Mount Type", mountType, [
                "Fixed Tilt",
                "Single Axis Tracker",
                "Dual Axis Tracker",
              ], (v) => setState(() => mountType = v!)),

              field(pileDepthController, "Pile Depth (m)"),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),

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
                              "name": farmNameController.text,
                              "location": locationController.text,
                            },
                            "site": {
                              "length": landLengthController.text,
                              "width": landWidthController.text,
                              "terrain": terrain,
                            },
                            "panel": {
                              "type": panelType,
                              "power": panelPowerController.text,
                              "length": panelLengthController.text,
                              "width": panelWidthController.text,
                            },
                            "array": {
                              "tilt": tiltController.text,
                              "rowSpacing": rowSpacingController.text,
                              "panelsPerRow": panelsPerRowController.text,
                              "rows": rowsController.text,
                            },
                            "electrical": {
                              "inverters": inverterCountController.text,
                              "transformer": transformerController.text,
                              "trenchWidth": trenchWidthController.text,
                            },
                            "structure": {
                              "mountType": mountType,
                              "pileDepth": pileDepthController.text,
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
                                  type: "solar_farm",
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
                      : const Text("Generate Solar Farm Layout"),
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
