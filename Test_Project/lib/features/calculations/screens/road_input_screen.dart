import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class RoadInputScreen extends StatefulWidget {
  const RoadInputScreen({super.key});

  @override
  State<RoadInputScreen> createState() => _RoadInputScreenState();
}

class _RoadInputScreenState extends State<RoadInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// 📏 UNIT SYSTEM
  String selectedUnit = "meter";
  final List<String> unitOptions = [
    "feet",
    "inch",
    "centimeter",
    "yard",
    "meter",
  ];

  /// CONTROLLERS
  final roadNameController = TextEditingController();
  final locationController = TextEditingController();
  final roadLengthController = TextEditingController();
  final carriageWidthController = TextEditingController();
  final lanesController = TextEditingController();
  final shoulderWidthController = TextEditingController();
  final speedController = TextEditingController();
  final trafficController = TextEditingController();
  final thicknessController = TextEditingController();
  final cbrController = TextEditingController();
  final drainWidthController = TextEditingController();
  final drainDepthController = TextEditingController();

  /// STATES
  String roadType = "Highway";
  String surfaceType = "Asphalt";
  String drainType = "Open Drain";
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Road Design Panel"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
        actions: [_unitPicker(), const SizedBox(width: 15)],
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
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
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

  Widget _unitPicker() {
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
          items: unitOptions
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
      children: [
        _sectionHeader("Project & Geometry"),
        _row([
          _cell("Road Name", roadNameController, isNumber: false),
          _cell("Total Length ($selectedUnit)", roadLengthController),
          _cell("Carriageway Width ($selectedUnit)", carriageWidthController),
          _cell("No. of Lanes", lanesController),
        ]),
        _divider(),
        _sectionHeader("Traffic & Classification"),
        _row([
          _cellDrop("Road Type", roadType, [
            "Highway",
            "City Road",
            "Rural Road",
          ], (v) => setState(() => roadType = v!)),
          _cell("Design Speed (km/h)", speedController),
          _cell("Traffic Volume (PCU)", trafficController),
          _cell("Shoulder Width ($selectedUnit)", shoulderWidthController),
        ]),
        _divider(),
        _sectionHeader("Pavement & Drainage"),
        _row([
          _cellDrop("Surface Type", surfaceType, [
            "Asphalt",
            "Concrete",
          ], (v) => setState(() => surfaceType = v!)),
          _cell("Pavement Thickness ($selectedUnit)", thicknessController),
          _cell("Subgrade CBR (%)", cbrController),
          _cellDrop("Drain Type", drainType, [
            "Open Drain",
            "Covered Drain",
          ], (v) => setState(() => drainType = v!)),
        ]),
        _divider(),
        _sectionHeader("Drawing Output"),
        _row([
          _cellDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
          ], (v) => setState(() => scale = v!)),
          _cellDrop("Sheet Size", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _cellDrop("Detail Level", detailLevel, [
            "Concept",
            "Standard",
            "Construction",
          ], (v) => setState(() => detailLevel = v!)),
          const Expanded(child: SizedBox()),
        ]),
        Padding(
          padding: const EdgeInsets.all(24),
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
        _sectionHeader("General Info ($selectedUnit)"),
        _mobileField("Road Name", roadNameController, isNumber: false),
        _mobileField("Width ($selectedUnit)", carriageWidthController),
        _mobileDrop("Road Type", roadType, [
          "Highway",
          "City Road",
          "Rural Road",
        ], (v) => setState(() => roadType = v!)),
        _sectionHeader("Pavement Data"),
        _mobileField("Thickness ($selectedUnit)", thicknessController),
        _mobileField("CBR (%)", cbrController),
        _mobileDrop("Surface", surfaceType, [
          "Asphalt",
          "Concrete",
        ], (v) => setState(() => surfaceType = v!)),
        const SizedBox(height: 20),
        _submitButton(),
        const SizedBox(height: 24),
      ],
    );
  }

  /// ================= UI COMPONENTS =================

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c, {bool isNumber = true}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

  Widget _divider() =>
      Divider(color: Colors.grey.shade300, indent: 15, endIndent: 15);

  Widget _submitButton() {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: isLoading ? null : _handleSubmission,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Generate Road Drawing",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "config": {"selected_unit": selectedUnit},
      "project": {
        "name": roadNameController.text,
        "location": locationController.text,
      },
      "geometry": {
        "length": roadLengthController.text,
        "width": carriageWidthController.text,
        "lanes": lanesController.text,
        "shoulderWidth": shoulderWidthController.text,
      },
      "pavement": {
        "surfaceType": surfaceType,
        "thickness": thicknessController.text,
        "cbr": cbrController.text,
      },
      "drawing": {"scale": scale, "sheetSize": sheetSize, "unit": selectedUnit},
    };

    try {
      await controller.generateDrawingFromInputs(type: "road", inputData: data);
      Get.snackbar(
        "Success",
        "Design calculated in $selectedUnit",
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
