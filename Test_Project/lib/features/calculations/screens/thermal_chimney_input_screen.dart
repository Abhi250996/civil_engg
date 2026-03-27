import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build_pro/features/calculations/controllers/calculation_controller.dart';

class ThermalChimneyInputScreen extends StatefulWidget {
  const ThermalChimneyInputScreen({super.key});

  @override
  State<ThermalChimneyInputScreen> createState() =>
      _ThermalChimneyInputScreenState();
}

class _ThermalChimneyInputScreenState extends State<ThermalChimneyInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS
  final heightController = TextEditingController();
  final shaftDiameterController = TextEditingController();
  final inletAreaController = TextEditingController();
  final outletAreaController = TextEditingController();
  final solarRadiationController = TextEditingController();
  final absorberEfficiencyController = TextEditingController();
  final inletTempController = TextEditingController();
  final outletTempController = TextEditingController();
  final airVelocityController = TextEditingController();
  final achController = TextEditingController();
  final conductivityController = TextEditingController();
  final insulationController = TextEditingController();
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  String glazingType = "Single Glazing";
  String orientation = "South";
  String shaftMaterial = "Reinforced Concrete";
  String foundationType = "Circular Footing";
  String scale = "1:100";
  String sheetSize = "A1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Thermal Chimney Design",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        actions: [
          // Global Unit Switcher
          Obx(
            () => DropdownButton<String>(
              value: controller.selectedUnit.value,
              underline: const SizedBox(),
              items: ["meter", "feet", "inch"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => controller.selectedUnit.value = v!,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue, bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 0.9],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Obx(() {
                    // Reactive Suffix Logic
                    bool isImperial = controller.selectedUnit.value != "meter";
                    String distUnit = isImperial ? "ft" : "m";
                    String areaUnit = isImperial ? "sq.ft" : "m²";
                    String tempUnit = isImperial ? "°F" : "°C";
                    String pressUnit = isImperial ? "psf" : "kN/m²";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader("Geometric Specifications"),
                        _mField("Chimney Height", heightController, distUnit),
                        _mField(
                          "Shaft Diameter",
                          shaftDiameterController,
                          distUnit,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _mField(
                                "Inlet Area",
                                inletAreaController,
                                areaUnit,
                              ),
                            ),
                            Expanded(
                              child: _mField(
                                "Outlet Area",
                                outletAreaController,
                                areaUnit,
                              ),
                            ),
                          ],
                        ),
                        _divider(),
                        _sectionHeader("Thermal & Solar Inputs"),
                        _mField(
                          "Solar Radiation",
                          solarRadiationController,
                          "W/m²",
                        ),
                        _mField(
                          "Absorber Efficiency",
                          absorberEfficiencyController,
                          "%",
                        ),
                        _mDrop(
                          "Glazing Type",
                          glazingType,
                          ["Single Glazing", "Double Glazing"],
                          (v) => setState(() => glazingType = v!),
                        ),
                        _mDrop(
                          "Orientation",
                          orientation,
                          ["North", "South", "East", "West"],
                          (v) => setState(() => orientation = v!),
                        ),
                        _divider(),
                        _sectionHeader("Airflow Performance"),
                        Row(
                          children: [
                            Expanded(
                              child: _mField(
                                "Inlet Temp",
                                inletTempController,
                                tempUnit,
                              ),
                            ),
                            Expanded(
                              child: _mField(
                                "Outlet Temp",
                                outletTempController,
                                tempUnit,
                              ),
                            ),
                          ],
                        ),
                        _mField(
                          "Air Velocity",
                          airVelocityController,
                          isImperial ? "fps" : "m/s",
                        ),
                        _mField("ACH", achController, "rate"),
                        _divider(),
                        _sectionHeader("Structural & Foundation"),
                        _mDrop(
                          "Material",
                          shaftMaterial,
                          ["Reinforced Concrete", "Brick Masonry", "Steel"],
                          (v) => setState(() => shaftMaterial = v!),
                        ),
                        _mField(
                          "Insulation Thk",
                          insulationController,
                          isImperial ? "in" : "mm",
                        ),
                        _mField("Wind Load", windLoadController, pressUnit),
                        _mField(
                          "Found. Depth",
                          foundationDepthController,
                          distUnit,
                        ),
                        _mField("Soil Capacity", soilController, pressUnit),
                        const SizedBox(height: 30),
                        _submitButton(),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── UI COMPONENTS ──────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _mField(String label, TextEditingController c, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => v!.isEmpty ? "Required" : null,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          suffixStyle: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _mDrop(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Divider(color: Colors.grey.shade200, thickness: 1.5),
  );

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          onPressed: isLoading ? null : _handleSubmission,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "GENERATE CHIMNEY DRAWING",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
        ),
      ),
    );
  }

  Future<void> _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "thermal_chimney",
        inputData: {
          "unitSystem": controller.selectedUnit.value,
          "geometry": {
            "height": heightController.text,
            "diameter": shaftDiameterController.text,
            "inletArea": inletAreaController.text,
            "outletArea": outletAreaController.text,
          },
          "solar": {
            "radiation": solarRadiationController.text,
            "efficiency": absorberEfficiencyController.text,
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
            "conductivity": conductivityController.text,
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
          "drawing": {"scale": scale, "sheetSize": sheetSize},
        },
      );

      Get.snackbar(
        "Success",
        res["message"] ?? "Processing complete",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
