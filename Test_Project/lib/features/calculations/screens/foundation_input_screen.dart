import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FoundationInputScreen extends StatefulWidget {
  const FoundationInputScreen({super.key});

  @override
  State<FoundationInputScreen> createState() => _FoundationInputScreenState();
}

class _FoundationInputScreenState extends State<FoundationInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// 📏 GLOBAL UNIT SYSTEM
  String selectedUnit = "meter";
  final List<String> globalUnits = ["feet", "inch", "centimeter", "meter"];

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final floorsController = TextEditingController(text: "1");
  final columnLoadController = TextEditingController();
  final soilBearingController = TextEditingController();
  final waterTableController = TextEditingController();
  final footingLengthController = TextEditingController();
  final footingWidthController = TextEditingController();
  final footingThicknessController = TextEditingController();
  final columnSizeController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final rebarDiameterController = TextEditingController();
  final rebarSpacingController = TextEditingController();

  /// STATES
  String structureType = "Building";
  String soilType = "Clay";
  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Foundation Design"),
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
            constraints: const BoxConstraints(maxWidth: 1400),
            padding: const EdgeInsets.all(14),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                      fontSize: 11,
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

  // ─── DESKTOP ─────────────────────────
  Widget _desktopLayout() {
    return Column(
      children: [
        _sectionTitle("Project & Site Context"),
        _row([
          _cell("Project Name", projectNameController, isNumber: false),
          _cellDrop("Structure", structureType, [
            "Building",
            "Tower",
            "Bridge",
            "Industrial",
          ], (v) => setState(() => structureType = v!)),
          _cell("Floors", floorsController),
          _cell("Water Table ($selectedUnit)", waterTableController),
        ]),
        _divider(),
        _sectionTitle("Geotechnical & Loading"),
        _row([
          _cell("Column Load (kN)", columnLoadController),
          _cell("Soil Bearing (kPa)", soilBearingController),
          _cellDrop("Soil Type", soilType, [
            "Clay",
            "Sand",
            "Rock",
            "Mixed",
          ], (v) => setState(() => soilType = v!)),
          _cell("Col. Spacing ($selectedUnit)", columnSpacingController),
        ]),
        _divider(),
        _sectionTitle("Footing Geometry ($selectedUnit)"),
        _row([
          _cell("Footing Length", footingLengthController),
          _cell("Footing Width", footingWidthController),
          _cell("Thickness", footingThicknessController),
          _cell("Column Size", columnSizeController),
        ]),
        _divider(),
        _sectionTitle("Reinforcement & Output"),
        _row([
          _cell("Rebar Dia (mm)", rebarDiameterController),
          _cell("Rebar Spacing (mm)", rebarSpacingController),
          _cellDrop("Scale", scale, [
            "1:20",
            "1:50",
            "1:100",
          ], (v) => setState(() => scale = v!)),
          _cellDrop("Sheet", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
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

  // ─── MOBILE ─────────────────────────
  Widget _mobileLayout() {
    return Column(
      children: [
        _mobileField("Project Name", projectNameController, isNumber: false),
        _mobileDrop("Structure", structureType, [
          "Building",
          "Tower",
          "Bridge",
        ], (v) => setState(() => structureType = v!)),
        _sectionTitle("Soil & Load"),
        _mobileField("Column Load (kN)", columnLoadController),
        _mobileField("Soil Bearing (kPa)", soilBearingController),
        _sectionTitle("Footing Details ($selectedUnit)"),
        _mobileField("Footing Width", footingWidthController),
        _mobileField("Thickness", footingThicknessController),
        _mobileField("Rebar Dia (mm)", rebarDiameterController),
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
            fontSize: 11,
            letterSpacing: 1.1,
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

  Widget _mobileDrop(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                "Generate Foundation Design",
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
      "structure": {"type": structureType, "floors": floorsController.text},
      "geotechnical": {
        "columnLoad": columnLoadController.text,
        "soilBearing": soilBearingController.text,
        "soilType": soilType,
        "waterTable": waterTableController.text,
      },
      "geometry": {
        "length": footingLengthController.text,
        "width": footingWidthController.text,
        "thickness": footingThicknessController.text,
        "columnSize": columnSizeController.text,
        "unit": selectedUnit,
      },
      "reinforcement": {
        "dia": rebarDiameterController.text,
        "spacing": rebarSpacingController.text,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "foundation",
        inputData: data,
      );
      Get.snackbar(
        "Success",
        "Foundation blueprint generated",
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
