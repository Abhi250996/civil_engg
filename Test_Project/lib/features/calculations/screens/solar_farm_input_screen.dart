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

  /// 🎨 YOUR COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS (UNCHANGED)
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
    final args = Get.arguments ?? {};
    final project = args['project'];

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Solar Farm Design"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),

      /// 🔥 GRADIENT BACKGROUND
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
              child: isDesktop
                  ? _desktopLayout(project)
                  : SingleChildScrollView(child: _mobileLayout(project)),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout(dynamic project) {
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
            _cell("Farm Name", farmNameController, false),
            _cell("Location", locationController, false),
            _cell("Length", landLengthController, true),
            _cell("Width", landWidthController, true),
          ]),
          _divider(),

          _row([
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
            _cell("Power", panelPowerController, true),
            _cell("Panel L", panelLengthController, true),
          ]),
          _divider(),

          _row([
            _cell("Panel W", panelWidthController, true),
            _cell("Tilt", tiltController, true),
            _cell("Row Spacing", rowSpacingController, true),
            _cell("Panels/Row", panelsPerRowController, true),
          ]),
          _divider(),

          _row([
            _cell("Rows", rowsController, true),
            _cell("Inverters", inverterCountController, true),
            _cell("Transformer", transformerController, true),
            _cell("Trench", trenchWidthController, true),
          ]),
          _divider(),

          _row([
            _cellDrop("Mount", mountType, [
              "Fixed Tilt",
              "Single Axis Tracker",
              "Dual Axis Tracker",
            ], (v) => setState(() => mountType = v!)),
            _cell("Pile Depth", pileDepthController, true),
            _cell("Soil", soilController, true),
            _cellDrop("Scale", scale, [
              "1:100",
              "1:200",
              "1:500",
            ], (v) => setState(() => scale = v!)),
          ]),
          _divider(),

          _row([
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
            const Expanded(child: SizedBox()),
          ]),
          _divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: _submitButton(), // 👈 SAME BUTTON
            ),
          ),
        ],
      ),
    );
  }

  // ================= MOBILE =================
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _mField("Farm Name", farmNameController, false),
          _mField("Location", locationController, false),
          _mField("Length", landLengthController, true),
          _mField("Width", landWidthController, true),
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
          _mField("Power", panelPowerController, true),
          _mField("Panel Length", panelLengthController, true),
          _mField("Panel Width", panelWidthController, true),
          _mField("Tilt", tiltController, true),
          _mField("Row Spacing", rowSpacingController, true),
          _mField("Panels/Row", panelsPerRowController, true),
          _mField("Rows", rowsController, true),
          _mField("Inverters", inverterCountController, true),
          _mField("Transformer", transformerController, true),
          _mField("Trench", trenchWidthController, true),
          _mDrop("Mount", mountType, [
            "Fixed Tilt",
            "Single Axis Tracker",
            "Dual Axis Tracker",
          ], (v) => setState(() => mountType = v!)),
          _mField("Pile Depth", pileDepthController, true),
          _mField("Soil", soilController, true),
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
          _submitButton(), // 👈 SAME BUTTON
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= BUTTON (UNCHANGED) =================
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

                final data = {
                  "project": {
                    "name": farmNameController.text,
                    "location": locationController.text,
                  },
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

                  setState(() => isLoading = false);

                  Get.snackbar(
                    res["success"] == true ? "Success" : "Error",
                    res["message"] ?? "Something went wrong",
                    backgroundColor: res["success"] == true
                        ? Colors.green
                        : Colors.red,
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
              },
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

  // ================= COMMON =================
  Widget _row(List<Widget> children) =>
      IntrinsicHeight(child: Row(children: children));

  Widget _cell(String label, TextEditingController c, bool isNumber) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
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

  Widget _mField(String label, TextEditingController c, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label),
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
