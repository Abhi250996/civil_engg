import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class BridgeInputScreen extends StatefulWidget {
  const BridgeInputScreen({super.key});

  @override
  State<BridgeInputScreen> createState() => _BridgeInputScreenState();
}

class _BridgeInputScreenState extends State<BridgeInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 UI COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color secondaryBlue = Color(0xFF3B82F6); // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> unitOptions = [
    "Meter",
    "Feet",
    "Foot",
    "Inch",
    "Yard",
    "Centimeter",
  ];

  /// CONTROLLERS
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final spansController = TextEditingController();
  final spanLengthController = TextEditingController();
  final pierSpacingController = TextEditingController();
  final clearanceController = TextEditingController();
  final designLoadController = TextEditingController();
  final soilController = TextEditingController();
  final foundationDepthController = TextEditingController();
  final riverWidthController = TextEditingController();
  final floodLevelController = TextEditingController();

  /// INDIVIDUAL UNIT STATES
  String lengthUnit = "Meter";
  String widthUnit = "Meter";
  String spanLengthUnit = "Meter";
  String pierSpacingUnit = "Meter";
  String clearanceUnit = "Meter";
  String depthUnit = "Meter";
  String riverWidthUnit = "Meter";
  String floodLevelUnit = "Meter";
  String soilUnit = "kN/m²";
  String loadUnit = "kN/m²";

  /// DROPDOWNS
  String bridgeType = "Beam Bridge";
  String material = "Reinforced Concrete";
  String foundationType = "Pile Foundation";
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
        title: const Text("Bridge Design"),
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

  // ─── DESKTOP (NO SCROLL, TABLE STYLE) ───────────────────────────────
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
              "Length",
              lengthController,
              lengthUnit,
              (v) => setState(() => lengthUnit = v!),
            ),
            _cellWithUnit(
              "Width",
              widthController,
              widthUnit,
              (v) => setState(() => widthUnit = v!),
            ),
            _cell("Spans", spansController),
            _cellWithUnit(
              "Span Length",
              spanLengthController,
              spanLengthUnit,
              (v) => setState(() => spanLengthUnit = v!),
            ),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Pier Spacing",
              pierSpacingController,
              pierSpacingUnit,
              (v) => setState(() => pierSpacingUnit = v!),
            ),
            _cellWithUnit(
              "Clearance",
              clearanceController,
              clearanceUnit,
              (v) => setState(() => clearanceUnit = v!),
            ),
            _cellDrop("Bridge Type", bridgeType, [
              "Beam Bridge",
              "Arch Bridge",
              "Suspension Bridge",
              "Cable Stayed Bridge",
            ], (v) => setState(() => bridgeType = v!)),
            _cellDrop("Material", material, [
              "Reinforced Concrete",
              "Steel",
              "Composite",
            ], (v) => setState(() => material = v!)),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Design Load",
              designLoadController,
              loadUnit,
              (v) => setState(() => loadUnit = v!),
              customUnits: ["kN/m²", "psf"],
            ),
            _cellDrop("Foundation", foundationType, [
              "Pile Foundation",
              "Open Foundation",
              "Well Foundation",
            ], (v) => setState(() => foundationType = v!)),
            _cellWithUnit(
              "Depth",
              foundationDepthController,
              depthUnit,
              (v) => setState(() => depthUnit = v!),
            ),
            _cellWithUnit(
              "Soil",
              soilController,
              soilUnit,
              (v) => setState(() => soilUnit = v!),
              customUnits: ["kN/m²", "psf"],
            ),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "River Width",
              riverWidthController,
              riverWidthUnit,
              (v) => setState(() => riverWidthUnit = v!),
            ),
            _cellWithUnit(
              "Flood Level",
              floodLevelController,
              floodLevelUnit,
              (v) => setState(() => floodLevelUnit = v!),
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
          _row([
            _cellDrop("Detail", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const Expanded(child: SizedBox()),
            const Expanded(child: SizedBox()),
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

  // ─── MOBILE ─────────────────────────────────────────────────────────
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
          _mobileFieldWithUnit(
            "Length",
            lengthController,
            lengthUnit,
            (v) => setState(() => lengthUnit = v!),
          ),
          _mobileFieldWithUnit(
            "Width",
            widthController,
            widthUnit,
            (v) => setState(() => widthUnit = v!),
          ),
          _mobileField("Spans", spansController),
          _mobileFieldWithUnit(
            "Span Length",
            spanLengthController,
            spanLengthUnit,
            (v) => setState(() => spanLengthUnit = v!),
          ),
          _mobileFieldWithUnit(
            "Pier Spacing",
            pierSpacingController,
            pierSpacingUnit,
            (v) => setState(() => pierSpacingUnit = v!),
          ),
          _mobileFieldWithUnit(
            "Clearance",
            clearanceController,
            clearanceUnit,
            (v) => setState(() => clearanceUnit = v!),
          ),
          _mobileDrop("Bridge Type", bridgeType, [
            "Beam Bridge",
            "Arch Bridge",
            "Suspension Bridge",
            "Cable Stayed Bridge",
          ], (v) => setState(() => bridgeType = v!)),
          _mobileDrop("Material", material, [
            "Reinforced Concrete",
            "Steel",
            "Composite",
          ], (v) => setState(() => material = v!)),
          _mobileFieldWithUnit(
            "Design Load",
            designLoadController,
            loadUnit,
            (v) => setState(() => loadUnit = v!),
            customUnits: ["kN/m²", "psf"],
          ),
          _mobileDrop("Foundation", foundationType, [
            "Pile Foundation",
            "Open Foundation",
            "Well Foundation",
          ], (v) => setState(() => foundationType = v!)),
          _mobileFieldWithUnit(
            "Depth",
            foundationDepthController,
            depthUnit,
            (v) => setState(() => depthUnit = v!),
          ),
          _mobileFieldWithUnit(
            "Soil",
            soilController,
            soilUnit,
            (v) => setState(() => soilUnit = v!),
            customUnits: ["kN/m²", "psf"],
          ),
          _mobileFieldWithUnit(
            "River Width",
            riverWidthController,
            riverWidthUnit,
            (v) => setState(() => riverWidthUnit = v!),
          ),
          _mobileFieldWithUnit(
            "Flood Level",
            floodLevelController,
            floodLevelUnit,
            (v) => setState(() => floodLevelUnit = v!),
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
    String currentUnit,
    Function(String?) onUnitChanged, {
    List<String>? customUnits,
  }) {
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
              child: _unitPicker(
                currentUnit,
                customUnits ?? unitOptions,
                onUnitChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileFieldWithUnit(
    String label,
    TextEditingController c,
    String currentUnit,
    Function(String?) onUnitChanged, {
    List<String>? customUnits,
  }) {
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
            child: _unitPicker(
              currentUnit,
              customUnits ?? unitOptions,
              onUnitChanged,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= BASIC HELPERS =================
  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
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
        keyboardType: TextInputType.number,
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
        onPressed: isLoading ? null : _handleSubmit,
        child: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Bridge Drawing"),
      ),
    );
  }

  void _handleSubmit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "geometry": {
        "length": {"val": lengthController.text, "unit": lengthUnit},
        "width": {"val": widthController.text, "unit": widthUnit},
        "spans": spansController.text,
        "spanLength": {
          "val": spanLengthController.text,
          "unit": spanLengthUnit,
        },
        "pierSpacing": {
          "val": pierSpacingController.text,
          "unit": pierSpacingUnit,
        },
        "clearance": {"val": clearanceController.text, "unit": clearanceUnit},
      },
      "structure": {
        "bridgeType": bridgeType,
        "material": material,
        "designLoad": {"val": designLoadController.text, "unit": loadUnit},
      },
      "foundation": {
        "type": foundationType,
        "depth": {"val": foundationDepthController.text, "unit": depthUnit},
        "soilBearingCapacity": {"val": soilController.text, "unit": soilUnit},
      },
      "environment": {
        "riverWidth": {
          "val": riverWidthController.text,
          "unit": riverWidthUnit,
        },
        "floodLevel": {
          "val": floodLevelController.text,
          "unit": floodLevelUnit,
        },
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final response = await controller.generateDrawingFromInputs(
        type: "bridge",
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
