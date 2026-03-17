import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/features/calculations/controllers/calculation_controller.dart';

class ThermalChimneyInputScreen extends StatefulWidget {
  const ThermalChimneyInputScreen({super.key});

  @override
  State<ThermalChimneyInputScreen> createState() =>
      _ThermalChimneyInputScreenState();
}

class _ThermalChimneyInputScreenState extends State<ThermalChimneyInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// ✅ LOADER ADDED
  bool isLoading = false;

  /// ================= GEOMETRY =================
  final heightController = TextEditingController();
  final shaftDiameterController = TextEditingController();
  final inletAreaController = TextEditingController();
  final outletAreaController = TextEditingController();

  /// ================= SOLAR =================
  final solarRadiationController = TextEditingController();
  final absorberEfficiencyController = TextEditingController();

  String glazingType = "Single Glazing";
  String orientation = "South";

  /// ================= AIR FLOW =================
  final inletTempController = TextEditingController();
  final outletTempController = TextEditingController();
  final airVelocityController = TextEditingController();
  final achController = TextEditingController();

  /// ================= MATERIAL =================
  String shaftMaterial = "Reinforced Concrete";
  final conductivityController = TextEditingController();
  final insulationController = TextEditingController();

  /// ================= STRUCTURAL =================
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();

  /// ================= FOUNDATION =================
  String foundationType = "Circular Footing";
  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  /// ================= DRAWING =================
  String scale = "1:100";
  String sheetSize = "A1";

  @override
  void dispose() {
    heightController.dispose();
    shaftDiameterController.dispose();
    inletAreaController.dispose();
    outletAreaController.dispose();
    solarRadiationController.dispose();
    absorberEfficiencyController.dispose();
    inletTempController.dispose();
    outletTempController.dispose();
    airVelocityController.dispose();
    achController.dispose();
    conductivityController.dispose();
    insulationController.dispose();
    windLoadController.dispose();
    seismicZoneController.dispose();
    foundationDepthController.dispose();
    soilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments?['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Thermal Chimney Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project"),
              Text("Project: ${project?.name ?? "Unnamed"}"),

              /// GEOMETRY
              sectionTitle("Geometry"),
              field(heightController, "Chimney Height (m)"),
              field(shaftDiameterController, "Shaft Diameter (m)"),
              field(inletAreaController, "Air Inlet Area (m²)"),
              field(outletAreaController, "Air Outlet Area (m²)"),

              /// SOLAR
              sectionTitle("Solar Design"),
              field(solarRadiationController, "Solar Radiation (W/m²)"),
              field(absorberEfficiencyController, "Absorber Efficiency (%)"),

              dropdown("Glazing Type", glazingType, [
                "Single Glazing",
                "Double Glazing",
              ], (v) => setState(() => glazingType = v!)),

              dropdown("Orientation", orientation, [
                "North",
                "South",
                "East",
                "West",
              ], (v) => setState(() => orientation = v!)),

              /// AIR FLOW
              sectionTitle("Air Flow / Ventilation"),
              field(inletTempController, "Inlet Temperature (°C)"),
              field(outletTempController, "Outlet Temperature (°C)"),
              field(airVelocityController, "Air Velocity (m/s)"),
              field(achController, "Air Changes per Hour (ACH)"),

              /// MATERIAL
              sectionTitle("Material"),
              dropdown(
                "Shaft Material",
                shaftMaterial,
                ["Reinforced Concrete", "Brick Masonry", "Steel"],
                (v) => setState(() => shaftMaterial = v!),
              ),

              field(conductivityController, "Thermal Conductivity (W/mK)"),
              field(insulationController, "Insulation Thickness (mm)"),

              /// STRUCTURAL
              sectionTitle("Structural"),
              field(windLoadController, "Wind Load (kN/m²)"),
              field(seismicZoneController, "Seismic Zone"),

              /// FOUNDATION
              sectionTitle("Foundation"),
              dropdown(
                "Foundation Type",
                foundationType,
                ["Circular Footing", "Raft", "Pile"],
                (v) => setState(() => foundationType = v!),
              ),

              field(foundationDepthController, "Foundation Depth (m)"),
              field(soilController, "Soil Bearing Capacity (kN/m²)"),

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
              ], (v) => setState(() => sheetSize = v!)),

              const SizedBox(height: 30),

              /// ✅ LOADER BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

                          try {
                            final res = await controller
                                .generateDrawingFromInputs(
                                  type: "thermal_chimney",
                                  inputData: {
                                    "geometry": {
                                      "height": heightController.text,
                                      "diameter": shaftDiameterController.text,
                                      "inletArea": inletAreaController.text,
                                      "outletArea": outletAreaController.text,
                                    },
                                    "solar": {
                                      "radiation":
                                          solarRadiationController.text,
                                      "efficiency":
                                          absorberEfficiencyController.text,
                                      "glazing": glazingType,
                                      "orientation": orientation,
                                    },
                                    "airflow": {
                                      "inletTemp": inletTempController.text,
                                      "outletTemp": outletTempController.text,
                                      "velocity": airVelocityController.text,
                                      "ach": achController.text,
                                    },
                                    "material": {
                                      "type": shaftMaterial,
                                      "conductivity":
                                          conductivityController.text,
                                      "insulation": insulationController.text,
                                    },
                                    "structure": {
                                      "windLoad": windLoadController.text,
                                      "seismicZone": seismicZoneController.text,
                                    },
                                    "foundation": {
                                      "type": foundationType,
                                      "depth": foundationDepthController.text,
                                      "soil": soilController.text,
                                    },
                                    "drawing": {
                                      "scale": scale,
                                      "sheetSize": sheetSize,
                                    },
                                  },
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
                      : const Text("Generate Thermal Chimney Drawing"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= COMMON =================

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget field(TextEditingController c, String label, {bool isNumber = true}) =>
      Padding(
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

  Widget dropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) => Padding(
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
