import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class ChimneyInputScreen extends StatefulWidget {
  const ChimneyInputScreen({super.key});

  @override
  State<ChimneyInputScreen> createState() => _ChimneyInputScreenState();
}

class _ChimneyInputScreenState extends State<ChimneyInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color secondaryBlue = Color(0xFF3B82F6); // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> lengthUnits = [
    "Meter",
    "Feet",
    "Foot",
    "Inch",
    "Yard",
    "Centimeter",
  ];
  final List<String> tempUnits = ["°C", "°F", "K"];
  final List<String> pressureUnits = ["kN/m²", "psf", "Pa", "kPa"];

  /// CONTROLLERS
  final heightController = TextEditingController();
  final baseDiameterController = TextEditingController();
  final topDiameterController = TextEditingController();
  final thicknessController = TextEditingController();
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();
  final gasTempController = TextEditingController();
  final gasVelocityController = TextEditingController();
  final liningThicknessController = TextEditingController();
  final foundationDepthController = TextEditingController();
  final foundationDiameterController = TextEditingController();
  final soilController = TextEditingController();

  /// INDIVIDUAL UNIT STATES
  String heightUnit = "Meter";
  String baseDiaUnit = "Meter";
  String topDiaUnit = "Meter";
  String thicknessUnit = "Centimeter";
  String windLoadUnit = "kN/m²";
  String gasTempUnit = "°C";
  String liningUnit = "Centimeter";
  String fDepthUnit = "Meter";
  String fDiaUnit = "Meter";
  String soilUnit = "kN/m²";

  /// DROPDOWNS
  String material = "Reinforced Concrete";
  String foundationType = "Circular Footing";
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Chimney Design"),
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

  // ─── DESKTOP (TABLE STYLE) ─────────────────────────────
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
              "Top Dia",
              topDiameterController,
              topDiaUnit,
              (v) => setState(() => topDiaUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Thickness",
              thicknessController,
              thicknessUnit,
              (v) => setState(() => thicknessUnit = v!),
              lengthUnits,
            ),
          ]),
          _divider(),
          _row([
            _cellDrop("Material", material, [
              "Reinforced Concrete",
              "Steel",
            ], (v) => setState(() => material = v!)),
            _cellWithUnit(
              "Wind Load",
              windLoadController,
              windLoadUnit,
              (v) => setState(() => windLoadUnit = v!),
              pressureUnits,
            ),
            _cell("Seismic Zone", seismicZoneController),
            _cell("Concrete", concreteGradeController),
          ]),
          _divider(),
          _row([
            _cell("Steel Grade", steelGradeController),
            _cellWithUnit(
              "Gas Temp",
              gasTempController,
              gasTempUnit,
              (v) => setState(() => gasTempUnit = v!),
              tempUnits,
            ),
            _cell("Velocity (m/s)", gasVelocityController),
            _cellWithUnit(
              "Lining",
              liningThicknessController,
              liningUnit,
              (v) => setState(() => liningUnit = v!),
              lengthUnits,
            ),
          ]),
          _divider(),
          _row([
            _cellDrop("Foundation", foundationType, [
              "Circular Footing",
              "Raft",
              "Pile Foundation",
            ], (v) => setState(() => foundationType = v!)),
            _cellWithUnit(
              "F Dia",
              foundationDiameterController,
              fDiaUnit,
              (v) => setState(() => fDiaUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "F Depth",
              foundationDepthController,
              fDepthUnit,
              (v) => setState(() => fDepthUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Soil",
              soilController,
              soilUnit,
              (v) => setState(() => soilUnit = v!),
              pressureUnits,
            ),
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
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
            _cellDrop("Detail", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const Expanded(child: SizedBox()),
          ]),
          _divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: _submitButton(),
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
            "Top Dia",
            topDiameterController,
            topDiaUnit,
            (v) => setState(() => topDiaUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Thickness",
            thicknessController,
            thicknessUnit,
            (v) => setState(() => thicknessUnit = v!),
            lengthUnits,
          ),
          _mobileDrop("Material", material, [
            "Reinforced Concrete",
            "Steel",
          ], (v) => setState(() => material = v!)),
          _mobileWithUnit(
            "Wind Load",
            windLoadController,
            windLoadUnit,
            (v) => setState(() => windLoadUnit = v!),
            pressureUnits,
          ),
          _mobileField("Seismic Zone", seismicZoneController),
          _mobileField("Concrete", concreteGradeController),
          _mobileField("Steel", steelGradeController),
          _mobileWithUnit(
            "Gas Temp",
            gasTempController,
            gasTempUnit,
            (v) => setState(() => gasTempUnit = v!),
            tempUnits,
          ),
          _mobileField("Velocity", gasVelocityController),
          _mobileWithUnit(
            "Lining",
            liningThicknessController,
            liningUnit,
            (v) => setState(() => liningUnit = v!),
            lengthUnits,
          ),
          _mobileDrop("Foundation", foundationType, [
            "Circular Footing",
            "Raft",
            "Pile Foundation",
          ], (v) => setState(() => foundationType = v!)),
          _mobileWithUnit(
            "F Dia",
            foundationDiameterController,
            fDiaUnit,
            (v) => setState(() => fDiaUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "F Depth",
            foundationDepthController,
            fDepthUnit,
            (v) => setState(() => fDepthUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Soil",
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
          _mobileDrop("Sheet", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _mobileDrop("Detail", detailLevel, [
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

  /// ================= REUSABLE UNIT HELPERS =================
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

  /// ================= COMMON HELPERS =================
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
            : const Text("Generate Chimney Drawing"),
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
        "topDiameter": {"val": topDiameterController.text, "unit": topDiaUnit},
        "thickness": {"val": thicknessController.text, "unit": thicknessUnit},
      },
      "structure": {
        "material": material,
        "windLoad": {"val": windLoadController.text, "unit": windLoadUnit},
        "seismicZone": seismicZoneController.text,
        "concreteGrade": concreteGradeController.text,
        "steelGrade": steelGradeController.text,
      },
      "thermal": {
        "gasTemp": {"val": gasTempController.text, "unit": gasTempUnit},
        "gasVelocity": gasVelocityController.text,
        "liningThickness": {
          "val": liningThicknessController.text,
          "unit": liningUnit,
        },
      },
      "foundation": {
        "type": foundationType,
        "diameter": {
          "val": foundationDiameterController.text,
          "unit": fDiaUnit,
        },
        "depth": {"val": foundationDepthController.text, "unit": fDepthUnit},
        "soilBearingCapacity": {"val": soilController.text, "unit": soilUnit},
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final response = await controller.generateDrawingFromInputs(
        type: "chimney",
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
