import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class RetainingWallInputScreen extends StatefulWidget {
  const RetainingWallInputScreen({super.key});

  @override
  State<RetainingWallInputScreen> createState() =>
      _RetainingWallInputScreenState();
}

class _RetainingWallInputScreenState extends State<RetainingWallInputScreen> {
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
  final projectNameController = TextEditingController();
  final heightController = TextEditingController();
  final baseWidthController = TextEditingController();
  final stemThicknessController = TextEditingController();
  final soilWeightController = TextEditingController();
  final frictionController = TextEditingController();
  final soilBearingController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();
  final filterThicknessController = TextEditingController();

  /// STATES
  String wallType = "Cantilever Wall";
  String drainType = "Weep Holes";
  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Retaining Wall Design"),
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
          _cell("Project Name", projectNameController, isNumber: false),
          _cell("Wall Height ($selectedUnit)", heightController),
          _cell("Base Width ($selectedUnit)", baseWidthController),
          _cellDrop("Wall Type", wallType, [
            "Cantilever Wall",
            "Gravity Wall",
            "Counterfort Wall",
          ], (v) => setState(() => wallType = v!)),
        ]),
        _divider(),
        _sectionHeader("Soil & Environment"),
        _row([
          _cell("Soil Weight (kN/$selectedUnit³)", soilWeightController),
          _cell("Friction Angle (°)", frictionController),
          _cell("Bearing Cap. (kPa)", soilBearingController),
          _cell("Seismic Zone", seismicZoneController),
        ]),
        _divider(),
        _sectionHeader("Drainage & Materials"),
        _row([
          _cellDrop("Drain Type", drainType, [
            "Weep Holes",
            "Drain Pipe",
          ], (v) => setState(() => drainType = v!)),
          _cell("Concrete Grade", concreteGradeController),
          _cell("Steel Grade (fy)", steelGradeController),
          _cell("Filter Thick. ($selectedUnit)", filterThicknessController),
        ]),
        _divider(),
        _sectionHeader("Drawing Settings"),
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
        _mobileField("Project Name", projectNameController, isNumber: false),
        _mobileField("Height ($selectedUnit)", heightController),
        _mobileDrop("Wall Type", wallType, [
          "Cantilever Wall",
          "Gravity Wall",
          "Counterfort Wall",
        ], (v) => setState(() => wallType = v!)),
        _sectionHeader("Soil Parameters"),
        _mobileField("Friction Angle", frictionController),
        _mobileField("Soil Weight (kN/$selectedUnit³)", soilWeightController),
        _sectionHeader("Materials"),
        _mobileField("Concrete Grade", concreteGradeController),
        _mobileField("Steel Grade", steelGradeController),
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
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Generate Technical Drawing",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "config": {"active_unit": selectedUnit},
      "project": {"name": projectNameController.text},
      "geometry": {
        "height": heightController.text,
        "baseWidth": baseWidthController.text,
        "filterThickness": filterThicknessController.text,
      },
      "soil": {
        "unitWeight": soilWeightController.text,
        "frictionAngle": frictionController.text,
        "bearingCapacity": soilBearingController.text,
      },
      "drawing": {"scale": scale, "sheet": sheetSize, "unit": selectedUnit},
    };

    try {
      await controller.generateDrawingFromInputs(
        type: "retaining_wall",
        inputData: data,
      );
      Get.snackbar(
        "Success",
        "Wall data processed in $selectedUnit",
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
