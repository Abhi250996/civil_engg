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

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> lengthUnits = ["Meter", "Feet", "Inch"];
  final List<String> flowUnits = ["m³/h", "gpm", "L/s"];
  final List<String> tempUnits = ["°C", "°F", "K"];
  final List<String> pressureUnits = ["kN/m²", "psf", "kPa"];

  /// CONTROLLERS
  final heightController = TextEditingController();
  final baseDiameterController = TextEditingController();
  final throatDiameterController = TextEditingController();
  final topDiameterController = TextEditingController();
  final shellThicknessController = TextEditingController();
  final waterFlowController = TextEditingController();
  final inletTempController = TextEditingController();
  final outletTempController = TextEditingController();
  final airFlowController = TextEditingController();
  final fanDiameterController = TextEditingController();
  final fanCountController = TextEditingController();
  final fillHeightController = TextEditingController();
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final soilController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();

  /// UNIT STATES
  String heightUnit = "Meter";
  String baseDiaUnit = "Meter";
  String throatDiaUnit = "Meter";
  String topDiaUnit = "Meter";
  String thickUnit = "Centimeter";
  String flowUnit = "m³/h";
  String tempInUnit = "°C";
  String tempOutUnit = "°C";
  String windUnit = "kN/m²";
  String soilUnit = "kN/m²";

  String towerType = "Natural Draft";
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Cooling Tower Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
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
              child: isDesktop
                  ? _desktopLayout(project)
                  : SingleChildScrollView(child: _mobileLayout(project)),
            ),
          ),
        ),
      ),
    );
  }

  // ─── DESKTOP ─────────────────────────────
  Widget _desktopLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Project: ${project?.name ?? "Unnamed"}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),
          ),
          _divider(),
          _row([
            _cellWithUnit(
              "Height",
              heightController,
              heightUnit,
              (v) => setState(() => heightUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Base Dia",
              baseDiameterController,
              baseDiaUnit,
              (v) => setState(() => baseDiaUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Throat Dia",
              throatDiameterController,
              throatDiaUnit,
              (v) => setState(() => throatDiaUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Top Dia",
              topDiameterController,
              topDiaUnit,
              (v) => setState(() => topDiaUnit = v!),
              lengthUnits,
            ),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Thickness",
              shellThicknessController,
              thickUnit,
              (v) => setState(() => thickUnit = v!),
              ["Centimeter", "Inch", "mm"],
            ),
            _cellWithUnit(
              "Water Flow",
              waterFlowController,
              flowUnit,
              (v) => setState(() => flowUnit = v!),
              flowUnits,
            ),
            _cellWithUnit(
              "Inlet Temp",
              inletTempController,
              tempInUnit,
              (v) => setState(() => tempInUnit = v!),
              tempUnits,
            ),
            _cellWithUnit(
              "Outlet Temp",
              outletTempController,
              tempOutUnit,
              (v) => setState(() => tempOutUnit = v!),
              tempUnits,
            ),
          ]),
          _divider(),
          _row([
            _cell("Air Flow (m³/s)", airFlowController),
            _cellDrop("Tower Type", towerType, [
              "Natural Draft",
              "Mechanical Draft",
            ], (v) => setState(() => towerType = v!)),
            _cell("Fan Dia", fanDiameterController),
            _cell("Fan Count", fanCountController),
          ]),
          _divider(),
          _row([
            _cell("Fill Height", fillHeightController),
            _cell("Concrete", concreteGradeController),
            _cell("Steel", steelGradeController),
            _cellWithUnit(
              "Wind Load",
              windLoadController,
              windUnit,
              (v) => setState(() => windUnit = v!),
              pressureUnits,
            ),
          ]),
          _divider(),
          _row([
            _cell("Seismic Zone", seismicZoneController),
            _cellWithUnit(
              "Soil Cap.",
              soilController,
              soilUnit,
              (v) => setState(() => soilUnit = v!),
              pressureUnits,
            ),
            _cellDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
            ], (v) => setState(() => scale = v!)),
            _cellDrop("Sheet", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
          ]),
          _divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _cellDrop("Detail Level", detailLevel, [
                  "Concept",
                  "Standard",
                  "Construction",
                ], (v) => setState(() => detailLevel = v!)),
                const Spacer(flex: 3),
                _submitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── MOBILE ─────────────────────────────
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Project: ${project?.name ?? "Unnamed"}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _mobileWithUnit(
            "Height",
            heightController,
            heightUnit,
            (v) => setState(() => heightUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Base Dia",
            baseDiameterController,
            baseDiaUnit,
            (v) => setState(() => baseDiaUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Throat Dia",
            throatDiameterController,
            throatDiaUnit,
            (v) => setState(() => throatDiaUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Top Dia",
            topDiameterController,
            topDiaUnit,
            (v) => setState(() => topDiaUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Thickness",
            shellThicknessController,
            thickUnit,
            (v) => setState(() => thickUnit = v!),
            ["Centimeter", "mm"],
          ),
          _mobileWithUnit(
            "Water Flow",
            waterFlowController,
            flowUnit,
            (v) => setState(() => flowUnit = v!),
            flowUnits,
          ),
          _mobileWithUnit(
            "Inlet Temp",
            inletTempController,
            tempInUnit,
            (v) => setState(() => tempInUnit = v!),
            tempUnits,
          ),
          _mobileWithUnit(
            "Outlet Temp",
            outletTempController,
            tempOutUnit,
            (v) => setState(() => tempOutUnit = v!),
            tempUnits,
          ),
          _mobileField("Air Flow (m³/s)", airFlowController),
          _mobileDrop("Tower Type", towerType, [
            "Natural Draft",
            "Mechanical Draft",
          ], (v) => setState(() => towerType = v!)),
          _mobileField("Fan Diameter", fanDiameterController),
          _mobileField("Fan Count", fanCountController),
          _mobileField("Fill Height", fillHeightController),
          _mobileField("Concrete Grade", concreteGradeController),
          _mobileField("Steel Grade", steelGradeController),
          _mobileWithUnit(
            "Wind Load",
            windLoadController,
            windUnit,
            (v) => setState(() => windUnit = v!),
            pressureUnits,
          ),
          _mobileField("Seismic Zone", seismicZoneController),
          _mobileWithUnit(
            "Soil Capacity",
            soilController,
            soilUnit,
            (v) => setState(() => soilUnit = v!),
            pressureUnits,
          ),
          _mobileDrop("Scale", scale, [
            "1:50",
            "1:100",
            "1:200",
          ], (v) => setState(() => scale = v!)),
          _mobileDrop("Sheet Size", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _mobileDrop("Detail Level", detailLevel, [
            "Concept",
            "Standard",
            "Construction",
          ], (v) => setState(() => detailLevel = v!)),
          const SizedBox(height: 10),
          _submitButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// ================= REUSABLE HELPERS =================
  Widget _unitPicker(
    String currentVal,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentVal,
        icon: const Icon(Icons.arrow_drop_down, size: 14, color: secondaryBlue),
        style: const TextStyle(
          color: primaryBlue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        items: options
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _cellWithUnit(
    String label,
    TextEditingController c,
    String unit,
    Function(String?) onUnitChanged,
    List<String> opts,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _unitPicker(unit, opts, onUnitChanged),
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
    Function(String?) onUnitChanged,
    List<String> opts,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _unitPicker(unit, opts, onUnitChanged),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          validator: (v) => v!.isEmpty ? "Required" : null,
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

  Widget _mobileField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _mobileDrop(
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

  Widget _submitButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
        onPressed: isLoading ? null : _handleSubmission,
        child: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Cooling Tower Drawing"),
      ),
    );
  }

  void _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "geometry": {
        "height": {"val": heightController.text, "unit": heightUnit},
        "baseDiameter": {
          "val": baseDiameterController.text,
          "unit": baseDiaUnit,
        },
        "throatDiameter": {
          "val": throatDiameterController.text,
          "unit": throatDiaUnit,
        },
        "topDiameter": {"val": topDiameterController.text, "unit": topDiaUnit},
        "shellThickness": {
          "val": shellThicknessController.text,
          "unit": thickUnit,
        },
      },
      "thermal": {
        "waterFlow": {"val": waterFlowController.text, "unit": flowUnit},
        "inletTemp": {"val": inletTempController.text, "unit": tempInUnit},
        "outletTemp": {"val": outletTempController.text, "unit": tempOutUnit},
        "airFlow": airFlowController.text,
      },
      "mechanical": {
        "towerType": towerType,
        "fanDiameter": fanDiameterController.text,
        "fanCount": fanCountController.text,
        "fillHeight": fillHeightController.text,
      },
      "structure": {
        "windLoad": {"val": windLoadController.text, "unit": windUnit},
        "seismicZone": seismicZoneController.text,
        "soilBearingCapacity": {"val": soilController.text, "unit": soilUnit},
        "concreteGrade": concreteGradeController.text,
        "steelGrade": steelGradeController.text,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final response = await controller.generateDrawingFromInputs(
        type: "cooling_tower",
        inputData: data,
      );
      setState(() => isLoading = false);
      Get.snackbar(
        response["success"] ? "Success" : "Error",
        response["message"] ?? "",
        backgroundColor: response["success"] ? Colors.green : Colors.red,
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
  }
}
