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

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// 📏 GLOBAL UNIT SYSTEM
  String selectedUnit = "meter";
  final List<String> globalUnits = [
    "feet",
    "inch",
    "centimeter",
    "yard",
    "meter",
  ];

  /// SPECIFIC UNIT OPTIONS
  final List<String> lengthUnits = ["km", "m", "mi", "ft"];
  final List<String> diaUnits = ["mm", "in"];
  final List<String> pressureUnits = ["bar", "psi", "kPa"];

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final lengthController = TextEditingController();
  final diameterController = TextEditingController();
  final thicknessController = TextEditingController();
  final flowRateController = TextEditingController();
  final pressureController = TextEditingController();
  final startElevationController = TextEditingController();
  final endElevationController = TextEditingController();
  final valveSpacingController = TextEditingController();
  final pumpStationsController = TextEditingController();
  final supportSpacingController = TextEditingController();

  /// STATES
  String mainLengthUnit = "km";
  String diaUnit = "mm";
  String pressUnit = "bar";
  String fluidType = "Water";
  String groundType = "Soil";
  String scale = "1:500";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Pipeline Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        actions: [_globalUnitPicker(), const SizedBox(width: 15)],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, secondaryBlue, bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1500),
            padding: const EdgeInsets.all(14),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: isDesktop ? _desktopLayout() : _mobileLayout(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _globalUnitPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedUnit,
          items: globalUnits
              .map(
                (u) => DropdownMenuItem(
                  value: u,
                  child: Text(
                    u.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedUnit = v!),
        ),
      ),
    );
  }

  // ─── DESKTOP ──────────────────────────────────────────
  Widget _desktopLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle("General Information"),
        _row([
          _cell("Project Name", projectNameController, isNumber: false),
          _cell("Location", locationController, isNumber: false),
          _cellDrop("Fluid Type", fluidType, [
            "Water",
            "Oil",
            "Gas",
            "Chemical",
          ], (v) => setState(() => fluidType = v!)),
          _cellDrop("Ground Type", groundType, [
            "Soil",
            "Rock",
            "Mixed",
          ], (v) => setState(() => groundType = v!)),
        ]),
        _divider(),
        _sectionTitle("Pipeline Dimensions"),
        _row([
          _cellWithUnit(
            "Total Length",
            lengthController,
            mainLengthUnit,
            (v) => setState(() => mainLengthUnit = v!),
            lengthUnits,
          ),
          _cellWithUnit(
            "Outer Diameter",
            diameterController,
            diaUnit,
            (v) => setState(() => diaUnit = v!),
            diaUnits,
          ),
          _cellWithUnit(
            "Wall Thickness",
            thicknessController,
            diaUnit,
            null,
            diaUnits,
          ),
          _cell("Support Spacing ($selectedUnit)", supportSpacingController),
        ]),
        _divider(),
        _sectionTitle("Hydraulics & Drawing"),
        _row([
          _cell("Flow Rate (m³/h)", flowRateController),
          _cellWithUnit(
            "Operating Pressure",
            pressureController,
            pressUnit,
            (v) => setState(() => pressUnit = v!),
            pressureUnits,
          ),
          _cellDrop("Scale", scale, [
            "1:200",
            "1:500",
            "1:1000",
          ], (v) => setState(() => scale = v!)),
          _cellDrop("Sheet Size", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
        ]),
        _divider(),
        _sectionTitle("Elevation Profile ($selectedUnit)"),
        _row([
          _cell("Start Elevation", startElevationController),
          _cell("End Elevation", endElevationController),
          _cell("Valve Spacing", valveSpacingController),
          _cell("Pump Stations", pumpStationsController),
        ]),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.centerRight,
            child: _submitButton(),
          ),
        ),
      ],
    );
  }

  // ─── MOBILE ───────────────────────────────────────────
  Widget _mobileLayout() {
    return Column(
      children: [
        _sectionTitle("General"),
        _mobileField("Project Name", projectNameController, isNumber: false),
        _mobileWithUnit(
          "Total Length",
          lengthController,
          mainLengthUnit,
          (v) => setState(() => mainLengthUnit = v!),
          lengthUnits,
        ),
        _mobileWithUnit(
          "Diameter",
          diameterController,
          diaUnit,
          (v) => setState(() => diaUnit = v!),
          diaUnits,
        ),
        _sectionTitle("Hydraulics"),
        _mobileField("Flow Rate", flowRateController),
        _mobileWithUnit(
          "Pressure",
          pressureController,
          pressUnit,
          (v) => setState(() => pressUnit = v!),
          pressureUnits,
        ),
        _sectionTitle("Route ($selectedUnit)"),
        _mobileField("Start Elevation", startElevationController),
        _mobileField("End Elevation", endElevationController),
        const SizedBox(height: 10),
        _submitButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ================= UI COMPONENTS =================

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _cellWithUnit(
    String label,
    TextEditingController c,
    String unit,
    Function(String?)? onUnitChanged,
    List<String> opts,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => v!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: unit,
                  icon: const Icon(Icons.arrow_drop_down, size: 14),
                  items: opts
                      .map(
                        (val) => DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onUnitChanged,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileWithUnit(
    String label,
    TextEditingController c,
    String unit,
    Function(String?)? onUnitChanged,
    List<String> opts,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: unit,
                items: opts
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),
                onChanged: onUnitChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c, {bool isNumber = true}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          validator: (v) => v!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
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
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _mobileField(
    String label,
    TextEditingController c, {
    bool isNumber = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade300, height: 1);

  Widget _submitButton() {
    return SizedBox(
      height: 45,
      width: 280,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: isLoading ? null : _handleSubmission,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Generate Pipeline Drawing",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "config": {"global_unit": selectedUnit},
      "project": {
        "name": projectNameController.text,
        "location": locationController.text,
      },
      "pipeline": {
        "length": lengthController.text,
        "diameter": diameterController.text,
        "thickness": thicknessController.text,
        "lengthUnit": mainLengthUnit,
        "diaUnit": diaUnit,
      },
      "hydraulics": {
        "flowRate": flowRateController.text,
        "pressure": pressureController.text,
        "pressureUnit": pressUnit,
        "fluid": fluidType,
      },
      "route": {
        "startElevation": startElevationController.text,
        "endElevation": endElevationController.text,
        "ground": groundType,
      },
      "drawing": {"scale": scale, "sheetSize": sheetSize, "unit": selectedUnit},
    };

    try {
      await controller.generateDrawingFromInputs(
        type: "pipeline",
        inputData: data,
      );
      Get.snackbar(
        "Success",
        "Pipeline drawing processed in $selectedUnit",
        backgroundColor: Colors.green,
        colorText: Colors.white,
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
