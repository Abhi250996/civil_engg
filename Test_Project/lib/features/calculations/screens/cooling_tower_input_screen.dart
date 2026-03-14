import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class CoolingTowerInputScreen extends StatefulWidget {
  const CoolingTowerInputScreen({super.key});

  @override
  State<CoolingTowerInputScreen> createState() =>
      _CoolingTowerInputScreenState();
}

class _CoolingTowerInputScreenState extends State<CoolingTowerInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// GEOMETRY
  final heightController = TextEditingController();
  final baseDiameterController = TextEditingController();
  final throatDiameterController = TextEditingController();
  final topDiameterController = TextEditingController();
  final shellThicknessController = TextEditingController();

  /// THERMAL
  final waterFlowController = TextEditingController();
  final inletTempController = TextEditingController();
  final outletTempController = TextEditingController();
  final airFlowController = TextEditingController();

  /// MECHANICAL
  final fanDiameterController = TextEditingController();
  final fanCountController = TextEditingController();
  final fillHeightController = TextEditingController();

  /// STRUCTURAL
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final soilController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();

  String towerType = "Natural Draft";

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Cooling Tower Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project"),
              Text("Project: ${project?.name ?? "Unnamed"}"),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Tower Geometry"),

              field(heightController, "Tower Height (m)"),
              field(baseDiameterController, "Base Diameter (m)"),
              field(throatDiameterController, "Throat Diameter (m)"),
              field(topDiameterController, "Top Diameter (m)"),
              field(shellThicknessController, "Shell Thickness (mm)"),

              const SizedBox(height: 20),

              /// THERMAL
              sectionTitle("Thermal Parameters"),

              field(waterFlowController, "Water Flow Rate (m³/hr)"),
              field(inletTempController, "Inlet Water Temperature (°C)"),
              field(outletTempController, "Outlet Water Temperature (°C)"),
              field(airFlowController, "Air Flow Rate (m³/s)"),

              const SizedBox(height: 20),

              /// MECHANICAL
              sectionTitle("Mechanical System"),

              dropdown("Tower Type", towerType, [
                "Natural Draft",
                "Mechanical Draft",
              ], (v) => setState(() => towerType = v!)),

              field(fanDiameterController, "Fan Diameter (m)"),
              field(fanCountController, "Number of Fans"),
              field(fillHeightController, "Fill Height (m)"),

              const SizedBox(height: 20),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),

              field(concreteGradeController, "Concrete Grade"),
              field(steelGradeController, "Steel Grade"),
              field(windLoadController, "Wind Load (kN/m²)"),
              field(seismicZoneController, "Seismic Zone"),
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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Cooling Tower Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "geometry": {
                        "height": heightController.text,
                        "baseDiameter": baseDiameterController.text,
                        "throatDiameter": throatDiameterController.text,
                        "topDiameter": topDiameterController.text,
                        "shellThickness": shellThicknessController.text,
                      },

                      "thermal": {
                        "waterFlow": waterFlowController.text,
                        "inletTemp": inletTempController.text,
                        "outletTemp": outletTempController.text,
                        "airFlow": airFlowController.text,
                      },

                      "mechanical": {
                        "towerType": towerType,
                        "fanDiameter": fanDiameterController.text,
                        "fanCount": fanCountController.text,
                        "fillHeight": fillHeightController.text,
                      },

                      "structure": {
                        "windLoad": windLoadController.text,
                        "seismicZone": seismicZoneController.text,
                        "soilBearingCapacity": soilController.text,
                        "concreteGrade": concreteGradeController.text,
                        "steelGrade": steelGradeController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "cooling_tower",
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
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
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
