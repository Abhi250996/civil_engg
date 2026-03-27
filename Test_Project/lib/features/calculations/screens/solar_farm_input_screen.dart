import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class SolarFarmInputScreen extends StatefulWidget {
  const SolarFarmInputScreen({super.key});

  @override
  State<SolarFarmInputScreen> createState() => _SolarFarmInputScreenState();
}

class _SolarFarmInputScreenState extends State<SolarFarmInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS
  final farmNameController = TextEditingController();
  final locationController = TextEditingController();
  final landLengthController = TextEditingController();
  final landWidthController = TextEditingController();
  final panelPowerController = TextEditingController();
  final panelLengthController = TextEditingController();
  final panelWidthController = TextEditingController();
  final tiltController = TextEditingController();
  final rowSpacingController = TextEditingController();
  final panelsPerRowController = TextEditingController();
  final rowsController = TextEditingController();
  final inverterCountController = TextEditingController();
  final transformerController = TextEditingController();
  final trenchWidthController = TextEditingController();
  final pileDepthController = TextEditingController();
  final soilController = TextEditingController();

  String terrain = "Flat";
  String panelType = "Monocrystalline";
  String mountType = "Fixed Tilt";
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Solar Farm Design"),
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
            child: Form(
              key: formKey,
              child: Obx(() {
                // Reactive Unit Suffixes
                String u =
                    controller.selectedUnit.value == "feet" ||
                        controller.selectedUnit.value == "inch"
                    ? "ft"
                    : "m";
                String sm =
                    controller.selectedUnit.value == "feet" ||
                        controller.selectedUnit.value == "inch"
                    ? "in"
                    : "mm";
                String soilUnit =
                    controller.selectedUnit.value == "feet" ||
                        controller.selectedUnit.value == "inch"
                    ? "psf"
                    : "kN/m²";

                return isDesktop
                    ? _desktopLayout(u, sm, soilUnit)
                    : SingleChildScrollView(
                        child: _mobileLayout(u, sm, soilUnit),
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout(String u, String sm, String soilUnit) {
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
            _cell("Farm Name", farmNameController, false),
            _cell("Location", locationController, false),
            _cell("Site Length", landLengthController, true, suffix: u),
          ]),
          _divider(),
          _row([
            _cell("Site Width", landWidthController, true, suffix: u),
            _cellDrop("Terrain", terrain, [
              "Flat",
              "Slight Slope",
              "Hill",
            ], (v) => setState(() => terrain = v!)),
            _cellDrop("Panel", panelType, [
              "Monocrystalline",
              "Polycrystalline",
              "Thin Film",
            ], (v) => setState(() => panelType = v!)),
            _cell("Power", panelPowerController, true, suffix: "W"),
          ]),
          _divider(),
          _row([
            _cell("Panel L", panelLengthController, true, suffix: sm),
            _cell("Panel W", panelWidthController, true, suffix: sm),
            _cell("Tilt", tiltController, true, suffix: "°"),
            _cell("Row Spacing", rowSpacingController, true, suffix: u),
          ]),
          _divider(),
          _row([
            _cell("Panels/Row", panelsPerRowController, true),
            _cell("Rows", rowsController, true),
            _cell("Inverters", inverterCountController, true),
            _cell("Transformer", transformerController, true),
          ]),
          _divider(),
          _row([
            _cell("Trench W", trenchWidthController, true, suffix: sm),
            _cellDrop("Mount", mountType, [
              "Fixed Tilt",
              "Single Axis Tracker",
              "Dual Axis Tracker",
            ], (v) => setState(() => mountType = v!)),
            _cell("Pile Depth", pileDepthController, true, suffix: u),
            _cell("Soil Capacity", soilController, true, suffix: soilUnit),
          ]),
          _divider(),
          _row([
            _cellDrop("Scale", scale, [
              "1:100",
              "1:200",
              "1:500",
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
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: _submitButton(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MOBILE =================
  Widget _mobileLayout(String u, String sm, String soilUnit) {
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
          _mField("Farm Name", farmNameController, false),
          _mField("Location", locationController, false),
          _mField("Site Length", landLengthController, true, suffix: u),
          _mField("Site Width", landWidthController, true, suffix: u),
          _mDrop("Terrain", terrain, [
            "Flat",
            "Slight Slope",
            "Hill",
          ], (v) => setState(() => terrain = v!)),
          _mDrop("Panel", panelType, [
            "Monocrystalline",
            "Polycrystalline",
            "Thin Film",
          ], (v) => setState(() => panelType = v!)),
          _mField("Power", panelPowerController, true, suffix: "W"),
          _mField("Panel Length", panelLengthController, true, suffix: sm),
          _mField("Panel Width", panelWidthController, true, suffix: sm),
          _mField("Tilt", tiltController, true, suffix: "°"),
          _mField("Row Spacing", rowSpacingController, true, suffix: u),
          _mField("Panels/Row", panelsPerRowController, true),
          _mField("Rows", rowsController, true),
          _mField("Inverters", inverterCountController, true),
          _mField("Transformer", transformerController, true),
          _mField("Trench Width", trenchWidthController, true, suffix: sm),
          _mDrop("Mount Type", mountType, [
            "Fixed Tilt",
            "Single Axis Tracker",
            "Dual Axis Tracker",
          ], (v) => setState(() => mountType = v!)),
          _mField("Pile Depth", pileDepthController, true, suffix: u),
          _mField("Soil Capacity", soilController, true, suffix: soilUnit),
          _mDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
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
        onPressed: isLoading ? null : _handleSubmit,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text("Generate Solar Farm Layout"),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      "project": {
        "name": farmNameController.text,
        "location": locationController.text,
      },
      "unitSystem": controller.selectedUnit.value,
      "site": {
        "length": landLengthController.text,
        "width": landWidthController.text,
        "terrain": terrain,
      },
      "panel": {
        "type": panelType,
        "power": panelPowerController.text,
        "length": panelLengthController.text,
        "width": panelWidthController.text,
      },
      "array": {
        "tilt": tiltController.text,
        "rowSpacing": rowSpacingController.text,
        "panelsPerRow": panelsPerRowController.text,
        "rows": rowsController.text,
      },
      "electrical": {
        "inverters": inverterCountController.text,
        "transformer": transformerController.text,
        "trenchWidth": trenchWidthController.text,
      },
      "structure": {
        "mountType": mountType,
        "pileDepth": pileDepthController.text,
        "soilBearingCapacity": soilController.text,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "solar_farm",
        inputData: data,
      );
      Get.snackbar(
        res["success"] == true ? "Success" : "Error",
        res["message"] ?? "Processing complete",
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
    String suffix = "",
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
          decoration: InputDecoration(labelText: label, suffixText: suffix),
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
                  child: Text(e, style: const TextStyle(fontSize: 12)),
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
    String suffix = "",
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label, suffixText: suffix),
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
}
