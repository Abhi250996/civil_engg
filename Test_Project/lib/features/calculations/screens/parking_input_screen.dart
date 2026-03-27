import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class ParkingInputScreen extends StatefulWidget {
  const ParkingInputScreen({super.key});

  @override
  State<ParkingInputScreen> createState() => _ParkingInputScreenState();
}

class _ParkingInputScreenState extends State<ParkingInputScreen> {
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
  final List<String> lengthUnits = ["m", "ft", "in"];

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final slotWidthController = TextEditingController(text: "2.5");
  final slotLengthController = TextEditingController(text: "5.0");
  final slotCountController = TextEditingController();
  final laneWidthController = TextEditingController(text: "6");
  final entryWidthController = TextEditingController(text: "4");
  final exitWidthController = TextEditingController(text: "4");
  final floorsController = TextEditingController(text: "1");
  final rampWidthController = TextEditingController(text: "4");
  final rampSlopeController = TextEditingController(text: "12");

  /// STATES
  String mainUnit = "m";
  String parkingType = "Surface Parking";
  String orientation = "North";
  String parkingAngle = "90°";
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Parking Layout Design"),
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

  // ─── DESKTOP ──────────────────────────────────────────
  Widget _desktopLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle("General & Site Info"),
        _row([
          _cell("Project Name", projectNameController, isNumber: false),
          _cellDrop("Parking Type", parkingType, [
            "Surface Parking",
            "Basement Parking",
            "Multi-Level Parking",
          ], (v) => setState(() => parkingType = v!)),
          _cell("Site Length ($selectedUnit)", lengthController),
          _cell("Site Width ($selectedUnit)", widthController),
        ]),
        _divider(),
        _sectionTitle("Slot & Layout Geometry"),
        _row([
          _cell("Slot Width ($selectedUnit)", slotWidthController),
          _cell("Slot Length ($selectedUnit)", slotLengthController),
          _cellDrop("Parking Angle", parkingAngle, [
            "90°",
            "60°",
            "45°",
          ], (v) => setState(() => parkingAngle = v!)),
          _cell("Target Slots", slotCountController),
        ]),
        _divider(),
        _sectionTitle("Circulation & Access ($selectedUnit)"),
        _row([
          _cell("Lane Width", laneWidthController),
          _cell("Entry Width", entryWidthController),
          _cell("Exit Width", exitWidthController),
          _cellDrop("Orientation", orientation, [
            "North",
            "South",
            "East",
            "West",
          ], (v) => setState(() => orientation = v!)),
        ]),
        _divider(),
        _sectionTitle("Vertical & Output"),
        _row([
          _cell("Total Floors", floorsController),
          _cell("Ramp Width ($selectedUnit)", rampWidthController),
          _cell("Ramp Slope (%)", rampSlopeController),
          _cellDrop("Sheet Size", sheetSize, [
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

  // ─── MOBILE ───────────────────────────────────────────
  Widget _mobileLayout() {
    return Column(
      children: [
        _sectionTitle("General"),
        _mobileField("Project Name", projectNameController, isNumber: false),
        _mobileDrop("Type", parkingType, [
          "Surface",
          "Basement",
          "Multi-Level",
        ], (v) => setState(() => parkingType = v!)),
        _sectionTitle("Site Dimensions ($selectedUnit)"),
        _mobileField("Site Width", widthController),
        _mobileField("Site Length", lengthController),
        _sectionTitle("Slot Details ($selectedUnit)"),
        _mobileField("Slot Width", slotWidthController),
        _mobileDrop("Angle", parkingAngle, [
          "90°",
          "60°",
          "45°",
        ], (v) => setState(() => parkingAngle = v!)),
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
                "Generate Parking Layout",
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
      "site": {
        "length": lengthController.text,
        "width": widthController.text,
        "unit": selectedUnit,
        "orientation": orientation,
      },
      "parking": {
        "type": parkingType,
        "slotWidth": slotWidthController.text,
        "slotLength": slotLengthController.text,
        "slots": slotCountController.text,
        "angle": parkingAngle,
      },
      "circulation": {
        "laneWidth": laneWidthController.text,
        "entryWidth": entryWidthController.text,
        "exitWidth": exitWidthController.text,
      },
      "drawing": {"scale": scale, "sheetSize": sheetSize, "unit": selectedUnit},
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "parking",
        inputData: data,
      );
      Get.snackbar(
        "Success",
        "Parking layout generated in $selectedUnit",
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
