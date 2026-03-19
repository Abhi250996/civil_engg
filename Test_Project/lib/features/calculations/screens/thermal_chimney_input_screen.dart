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

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS (UNCHANGED)
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
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Thermal Chimney Design"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),

      /// 🔥 GRADIENT
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            padding: const EdgeInsets.all(20),

            child: Form(
              key: formKey,
              child: isDesktop
                  ? _desktopLayout(project)
                  : SingleChildScrollView(child: _mobileLayout(project)),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _row([
            _cell("Height", heightController),
            _cell("Diameter", shaftDiameterController),
            _cell("Inlet Area", inletAreaController),
            _cell("Outlet Area", outletAreaController),
          ]),
          _divider(),

          _row([
            _cell("Solar Radiation", solarRadiationController),
            _cell("Efficiency", absorberEfficiencyController),
            _cellDrop("Glazing", glazingType, [
              "Single Glazing",
              "Double Glazing",
            ], (v) => setState(() => glazingType = v!)),
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
          ]),
          _divider(),

          _row([
            _cell("Inlet Temp", inletTempController),
            _cell("Outlet Temp", outletTempController),
            _cell("Velocity", airVelocityController),
            _cell("ACH", achController),
          ]),
          _divider(),

          _row([
            _cellDrop("Material", shaftMaterial, [
              "Reinforced Concrete",
              "Brick Masonry",
              "Steel",
            ], (v) => setState(() => shaftMaterial = v!)),
            _cell("Conductivity", conductivityController),
            _cell("Insulation", insulationController),
            _cell("Wind Load", windLoadController),
          ]),
          _divider(),

          _row([
            _cell("Seismic Zone", seismicZoneController),
            _cellDrop("Foundation", foundationType, [
              "Circular Footing",
              "Raft",
              "Pile",
            ], (v) => setState(() => foundationType = v!)),
            _cell("Foundation Depth", foundationDepthController),
            _cell("Soil", soilController),
          ]),
          _divider(),

          _row([
            _cellDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
            ], (v) => setState(() => scale = v!)),
            _cellDrop("Sheet", sheetSize, [
              "A0",
              "A1",
              "A2",
            ], (v) => setState(() => sheetSize = v!)),
            const Expanded(child: SizedBox()),
            const Expanded(child: SizedBox()),
          ]),
          _divider(),

          Padding(padding: const EdgeInsets.all(16), child: _submitButton()),
        ],
      ),
    );
  }

  // ================= MOBILE =================
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _mField("Height", heightController),
          _mField("Diameter", shaftDiameterController),
          _mField("Inlet Area", inletAreaController),
          _mField("Outlet Area", outletAreaController),
          _mField("Solar Radiation", solarRadiationController),
          _mField("Efficiency", absorberEfficiencyController),
          _mDrop("Glazing", glazingType, [
            "Single Glazing",
            "Double Glazing",
          ], (v) => setState(() => glazingType = v!)),
          _mDrop("Orientation", orientation, [
            "North",
            "South",
            "East",
            "West",
          ], (v) => setState(() => orientation = v!)),
          _mField("Inlet Temp", inletTempController),
          _mField("Outlet Temp", outletTempController),
          _mField("Velocity", airVelocityController),
          _mField("ACH", achController),
          _mDrop("Material", shaftMaterial, [
            "Reinforced Concrete",
            "Brick Masonry",
            "Steel",
          ], (v) => setState(() => shaftMaterial = v!)),
          _mField("Conductivity", conductivityController),
          _mField("Insulation", insulationController),
          _mField("Wind Load", windLoadController),
          _mField("Seismic Zone", seismicZoneController),
          _mDrop("Foundation", foundationType, [
            "Circular Footing",
            "Raft",
            "Pile",
          ], (v) => setState(() => foundationType = v!)),
          _mField("Foundation Depth", foundationDepthController),
          _mField("Soil", soilController),
          _mDrop("Scale", scale, [
            "1:50",
            "1:100",
            "1:200",
          ], (v) => setState(() => scale = v!)),
          _mDrop("Sheet", sheetSize, [
            "A0",
            "A1",
            "A2",
          ], (v) => setState(() => sheetSize = v!)),

          const SizedBox(height: 20),
          _submitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= BUTTON (UNCHANGED) =================
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

                try {
                  final res = await controller.generateDrawingFromInputs(
                    type: "thermal_chimney",
                    inputData: {
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
    );
  }

  // ================= COMMON =================
  Widget _row(List<Widget> children) =>
      IntrinsicHeight(child: Row(children: children));

  Widget _cell(String label, TextEditingController c) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(labelText: label),
        ),
      ),
    );
  }

  Widget _cellDrop(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(labelText: label),
        ),
      ),
    );
  }

  Widget _mField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label),
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
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade200);
}
