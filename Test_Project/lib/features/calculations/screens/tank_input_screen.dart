import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TankInputScreen extends StatefulWidget {
  const TankInputScreen({super.key});

  @override
  State<TankInputScreen> createState() => _TankInputScreenState();
}

class _TankInputScreenState extends State<TankInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final capacityController = TextEditingController();
  final waterDepthController = TextEditingController();
  final diameterController = TextEditingController();
  final heightController = TextEditingController();
  final wallThicknessController = TextEditingController();
  final rebarDiameterController = TextEditingController();
  final rebarSpacingController = TextEditingController();
  final inletPipeController = TextEditingController();
  final outletPipeController = TextEditingController();
  final overflowPipeController = TextEditingController();
  final drainPipeController = TextEditingController();

  String tankType = "Overhead Tank";
  String concreteGrade = "M25";
  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Water Tank Design"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),
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
            // Wrap with Obx so the entire form reacts to unit changes
            child: Form(
              key: formKey,
              child: Obx(() {
                // Reactive Unit Labels
                String u = controller.selectedUnit.value == "meter"
                    ? "m"
                    : "ft";
                String vol = controller.selectedUnit.value == "meter"
                    ? "L"
                    : "gal";
                String mm = controller.selectedUnit.value == "meter"
                    ? "mm"
                    : "in";

                return isDesktop
                    ? _desktopLayout(u, vol, mm)
                    : SingleChildScrollView(child: _mobileLayout(u, vol, mm));
              }),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout(String u, String vol, String mm) {
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
            _cellDrop(
              "Unit System",
              controller.selectedUnit.value,
              ["meter", "feet", "inch", "centimeter"],
              (v) => controller.selectedUnit.value = v!,
            ),
            _cell("Project Name", projectNameController, false),
            _cell("Location", locationController, false),
            _cellDrop("Tank Type", tankType, [
              "Underground Tank",
              "Overhead Tank",
              "Ground Level Tank",
            ], (v) => setState(() => tankType = v!)),
          ]),
          _divider(),
          _row([
            _cell("Capacity", capacityController, true, unit: vol),
            _cell("Water Depth", waterDepthController, true, unit: u),
            _cell("Diameter", diameterController, true, unit: u),
            _cell("Height", heightController, true, unit: u),
          ]),
          _divider(),
          _row([
            _cell("Wall Thickness", wallThicknessController, true, unit: mm),
            _cellDrop("Concrete", concreteGrade, [
              "M20",
              "M25",
              "M30",
            ], (v) => setState(() => concreteGrade = v!)),
            _cell("Rebar Dia", rebarDiameterController, true, unit: mm),
            _cell("Rebar Spacing", rebarSpacingController, true, unit: mm),
          ]),
          _divider(),
          _row([
            _cell("Inlet Pipe", inletPipeController, true, unit: mm),
            _cell("Outlet Pipe", outletPipeController, true, unit: mm),
            _cell("Overflow Pipe", overflowPipeController, true, unit: mm),
            _cell("Drain Pipe", drainPipeController, true, unit: mm),
          ]),
          _divider(),
          _row([
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
            _cellDrop("Detail", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const Expanded(child: SizedBox()),
          ]),
          _divider(),
          Padding(padding: const EdgeInsets.all(16), child: _submitButton()),
        ],
      ),
    );
  }

  // ================= MOBILE =================
  Widget _mobileLayout(String u, String vol, String mm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _mDrop(
            "Unit System",
            controller.selectedUnit.value,
            ["meter", "feet", "inch", "centimeter"],
            (v) => controller.selectedUnit.value = v!,
          ),
          _mField("Project Name", projectNameController, false),
          _mField("Location", locationController, false),
          _mDrop("Tank Type", tankType, [
            "Underground Tank",
            "Overhead Tank",
            "Ground Level Tank",
          ], (v) => setState(() => tankType = v!)),
          _divider(),
          _mField("Capacity", capacityController, true, unit: vol),
          _mField("Water Depth", waterDepthController, true, unit: u),
          _mField("Diameter", diameterController, true, unit: u),
          _mField("Height", heightController, true, unit: u),
          _mField("Wall Thickness", wallThicknessController, true, unit: mm),
          _divider(),
          _mDrop("Concrete", concreteGrade, [
            "M20",
            "M25",
            "M30",
          ], (v) => setState(() => concreteGrade = v!)),
          _mField("Rebar Dia", rebarDiameterController, true, unit: mm),
          _mField("Rebar Spacing", rebarSpacingController, true, unit: mm),
          _divider(),
          _mField("Inlet Pipe", inletPipeController, true, unit: mm),
          _mField("Outlet Pipe", outletPipeController, true, unit: mm),
          _mField("Overflow Pipe", overflowPipeController, true, unit: mm),
          _mField("Drain Pipe", drainPipeController, true, unit: mm),
          _divider(),
          _mDrop("Scale", scale, [
            "1:20",
            "1:50",
            "1:100",
          ], (v) => setState(() => scale = v!)),
          _mDrop("Sheet", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _mDrop("Detail", detailLevel, [
            "Concept",
            "Standard",
            "Construction",
          ], (v) => setState(() => detailLevel = v!)),
          const SizedBox(height: 20),
          _submitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= BUTTON =================
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
        onPressed: isLoading ? null : _handleSubmission,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text("Generate Tank Drawing"),
      ),
    );
  }

  Future<void> _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      "project": {
        "name": projectNameController.text,
        "location": locationController.text,
      },
      "unitSystem": controller.selectedUnit.value, // Added unit context
      "tank": {
        "type": tankType,
        "capacity": capacityController.text,
        "waterDepth": waterDepthController.text,
        "diameter": diameterController.text,
        "height": heightController.text,
        "wallThickness": wallThicknessController.text,
      },
      "structure": {
        "concreteGrade": concreteGrade,
        "rebarDiameter": rebarDiameterController.text,
        "rebarSpacing": rebarSpacingController.text,
      },
      "pipes": {
        "inlet": inletPipeController.text,
        "outlet": outletPipeController.text,
        "overflow": overflowPipeController.text,
        "drain": drainPipeController.text,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "tank",
        inputData: data,
      );
      Get.snackbar(
        res["success"] == true ? "Success" : "Error",
        res["message"] ?? "Done",
        backgroundColor: res["success"] == true ? Colors.green : Colors.red,
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

  // ================= COMMON HELPERS =================
  Widget _row(List<Widget> children) =>
      IntrinsicHeight(child: Row(children: children));

  Widget _cell(
    String label,
    TextEditingController c,
    bool isNumber, {
    String unit = "",
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(labelText: label, suffixText: unit),
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
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(labelText: label),
        ),
      ),
    );
  }

  Widget _mField(
    String label,
    TextEditingController c,
    bool isNumber, {
    String unit = "",
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label, suffixText: unit),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

  Widget _divider() => Divider(color: Colors.grey.shade200, thickness: 1);
}
