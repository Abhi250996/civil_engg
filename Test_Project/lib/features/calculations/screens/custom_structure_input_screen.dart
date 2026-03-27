import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class CustomStructureInputScreen extends StatefulWidget {
  const CustomStructureInputScreen({super.key});

  @override
  State<CustomStructureInputScreen> createState() =>
      _CustomStructureInputScreenState();
}

class _CustomStructureInputScreenState
    extends State<CustomStructureInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> lengthUnits = ["Meter", "Feet", "mm"];
  final List<String> loadUnits = ["kN/m²", "psf", "kg/m²"];
  final List<String> soilUnits = ["kN/m²", "tsf", "kPa"];

  /// CONTROLLERS
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final levelsController = TextEditingController();
  final designLoadController = TextEditingController();
  final liveLoadController = TextEditingController();
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  /// UNIT STATES
  String lengthUnit = "Meter";
  String widthUnit = "Meter";
  String heightUnit = "Meter";
  String dLoadUnit = "kN/m²";
  String lLoadUnit = "kN/m²";
  String windUnit = "kN/m²";
  String depthUnit = "Meter";
  String soilUnit = "kN/m²";

  String materialType = "Concrete";
  String foundationType = "Isolated Footing";
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
        title: const Text("Custom Structure Design"),
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
            _cell("Structure Name", nameController, isNumber: false),
            _cell("Description", descController, isNumber: false),
            _cellWithUnit(
              "Length",
              lengthController,
              lengthUnit,
              (v) => setState(() => lengthUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Width",
              widthController,
              widthUnit,
              (v) => setState(() => widthUnit = v!),
              lengthUnits,
            ),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Total Height",
              heightController,
              heightUnit,
              (v) => setState(() => heightUnit = v!),
              lengthUnits,
            ),
            _cell("Number of Levels", levelsController),
            _cellDrop("Material", materialType, [
              "Concrete",
              "Steel",
              "Composite",
            ], (v) => setState(() => materialType = v!)),
            _cellWithUnit(
              "Design Load",
              designLoadController,
              dLoadUnit,
              (v) => setState(() => dLoadUnit = v!),
              loadUnits,
            ),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Live Load",
              liveLoadController,
              lLoadUnit,
              (v) => setState(() => lLoadUnit = v!),
              loadUnits,
            ),
            _cellWithUnit(
              "Wind Load",
              windLoadController,
              windUnit,
              (v) => setState(() => windUnit = v!),
              loadUnits,
            ),
            _cell("Seismic Zone", seismicZoneController),
            _cellDrop("Foundation", foundationType, [
              "Isolated Footing",
              "Raft",
              "Pile",
              "Strip Footing",
            ], (v) => setState(() => foundationType = v!)),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Found. Depth",
              foundationDepthController,
              depthUnit,
              (v) => setState(() => depthUnit = v!),
              lengthUnits,
            ),
            _cellWithUnit(
              "Soil Capacity",
              soilController,
              soilUnit,
              (v) => setState(() => soilUnit = v!),
              soilUnits,
            ),
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
          _mobileField("Structure Name", nameController, isNumber: false),
          _mobileField("Description", descController, isNumber: false),
          _mobileWithUnit(
            "Length",
            lengthController,
            lengthUnit,
            (v) => setState(() => lengthUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Width",
            widthController,
            widthUnit,
            (v) => setState(() => widthUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Height",
            heightController,
            heightUnit,
            (v) => setState(() => heightUnit = v!),
            lengthUnits,
          ),
          _mobileField("Levels", levelsController),
          _mobileDrop("Material", materialType, [
            "Concrete",
            "Steel",
            "Composite",
          ], (v) => setState(() => materialType = v!)),
          _mobileWithUnit(
            "Design Load",
            designLoadController,
            dLoadUnit,
            (v) => setState(() => dLoadUnit = v!),
            loadUnits,
          ),
          _mobileWithUnit(
            "Live Load",
            liveLoadController,
            lLoadUnit,
            (v) => setState(() => lLoadUnit = v!),
            loadUnits,
          ),
          _mobileWithUnit(
            "Wind Load",
            windLoadController,
            windUnit,
            (v) => setState(() => windUnit = v!),
            loadUnits,
          ),
          _mobileField("Seismic Zone", seismicZoneController),
          _mobileDrop("Foundation", foundationType, [
            "Isolated",
            "Raft",
            "Pile",
          ], (v) => setState(() => foundationType = v!)),
          _mobileWithUnit(
            "Foundation Depth",
            foundationDepthController,
            depthUnit,
            (v) => setState(() => depthUnit = v!),
            lengthUnits,
          ),
          _mobileWithUnit(
            "Soil Capacity",
            soilController,
            soilUnit,
            (v) => setState(() => soilUnit = v!),
            soilUnits,
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

  Widget _cell(String label, TextEditingController c, {bool isNumber = true}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  Widget _mobileField(
    String label,
    TextEditingController c, {
    bool isNumber = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
            : const Text("Generate Custom Drawing"),
      ),
    );
  }

  void _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "structure": {
        "name": nameController.text,
        "description": descController.text,
        "material": materialType,
      },
      "geometry": {
        "length": {"val": lengthController.text, "unit": lengthUnit},
        "width": {"val": widthController.text, "unit": widthUnit},
        "height": {"val": heightController.text, "unit": heightUnit},
        "levels": levelsController.text,
      },
      "loads": {
        "designLoad": {"val": designLoadController.text, "unit": dLoadUnit},
        "liveLoad": {"val": liveLoadController.text, "unit": lLoadUnit},
        "windLoad": {"val": windLoadController.text, "unit": windUnit},
        "seismicZone": seismicZoneController.text,
      },
      "foundation": {
        "type": foundationType,
        "depth": {"val": foundationDepthController.text, "unit": depthUnit},
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
        type: "custom",
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
