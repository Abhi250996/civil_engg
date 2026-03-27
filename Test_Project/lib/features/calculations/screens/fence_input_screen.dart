import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FenceInputScreen extends StatefulWidget {
  const FenceInputScreen({super.key});

  @override
  State<FenceInputScreen> createState() => _FenceInputScreenState();
}

class _FenceInputScreenState extends State<FenceInputScreen> {
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
  final boundaryLengthController = TextEditingController();
  final fenceHeightController = TextEditingController();
  final postSpacingController = TextEditingController();
  final postDiameterController = TextEditingController();
  final postDepthController = TextEditingController();
  final concreteGradeController = TextEditingController(text: "M20");
  final gateCountController = TextEditingController(text: "1");
  final gateWidthController = TextEditingController();

  /// STATES
  String fenceType = "Chain Link";
  String gateType = "Sliding";
  String scale = "1:100";
  String sheetSize = "A2";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Fence / Boundary Design"),
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
                  child: isDesktop
                      ? _desktopLayout(project)
                      : _mobileLayout(project),
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
  Widget _desktopLayout(dynamic project) {
    return Column(
      children: [
        _sectionTitle("Site Context - ${project?.name ?? "New Project"}"),
        _row([
          _cell("Project Name", projectNameController, isNumber: false),
          _cell("Location", locationController, isNumber: false),
          _cell("Boundary Length ($selectedUnit)", boundaryLengthController),
          _cell("Fence Height ($selectedUnit)", fenceHeightController),
        ]),
        _divider(),
        _sectionTitle("Fence Specifications"),
        _row([
          _cellDrop("Fence Type", fenceType, [
            "Chain Link",
            "Barbed Wire",
            "Steel Panel",
            "Concrete Wall",
          ], (v) => setState(() => fenceType = v!)),
          _cell("Post Spacing ($selectedUnit)", postSpacingController),
          _cell("Post Diameter (mm)", postDiameterController),
          _cell("Post Depth ($selectedUnit)", postDepthController),
        ]),
        _divider(),
        _sectionTitle("Structural & Access"),
        _row([
          _cell("Concrete Grade", concreteGradeController, isNumber: false),
          _cell("Gate Count", gateCountController),
          _cell("Gate Width ($selectedUnit)", gateWidthController),
          _cellDrop("Gate Type", gateType, [
            "Sliding",
            "Hinged",
            "Swing",
          ], (v) => setState(() => gateType = v!)),
        ]),
        _divider(),
        _sectionTitle("Blueprint Settings"),
        _row([
          _cellDrop("Scale", scale, [
            "1:50",
            "1:100",
            "1:200",
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
  Widget _mobileLayout(dynamic project) {
    return Column(
      children: [
        _sectionTitle("Boundary Overview"),
        _mobileField("Project Name", projectNameController, isNumber: false),
        _mobileField(
          "Boundary Length ($selectedUnit)",
          boundaryLengthController,
        ),
        _mobileDrop("Fence Type", fenceType, [
          "Chain Link",
          "Barbed Wire",
          "Steel Panel",
        ], (v) => setState(() => fenceType = v!)),
        _sectionTitle("Post & Foundation"),
        _mobileField("Post Spacing ($selectedUnit)", postSpacingController),
        _mobileField("Post Depth ($selectedUnit)", postDepthController),
        _sectionTitle("Access Control"),
        _mobileField("Gate Count", gateCountController),
        _mobileDrop("Gate Type", gateType, [
          "Sliding",
          "Hinged",
        ], (v) => setState(() => gateType = v!)),
        const SizedBox(height: 10),
        _submitButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ================= UI HELPERS =================

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
                "Generate Fence Blueprint",
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
      "boundary": {
        "length": boundaryLengthController.text,
        "height": fenceHeightController.text,
        "unit": selectedUnit,
      },
      "fence": {
        "type": fenceType,
        "postSpacing": postSpacingController.text,
        "postDiameter": postDiameterController.text,
        "postDepth": postDepthController.text,
        "concreteGrade": concreteGradeController.text,
      },
      "gate": {
        "count": gateCountController.text,
        "width": gateWidthController.text,
        "type": gateType,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "fence",
        inputData: data,
      );
      Get.snackbar(
        "Success",
        "Fence drawing generated successfully",
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
