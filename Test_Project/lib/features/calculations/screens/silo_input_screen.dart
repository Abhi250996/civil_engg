import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class SiloInputScreen extends StatefulWidget {
  const SiloInputScreen({super.key});

  @override
  State<SiloInputScreen> createState() => _SiloInputScreenState();
}

class _SiloInputScreenState extends State<SiloInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS (Your palette)
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final siloNameController = TextEditingController();
  final locationController = TextEditingController();
  final heightController = TextEditingController();
  final diameterController = TextEditingController();
  final thicknessController = TextEditingController();
  final hopperAngleController = TextEditingController();
  final capacityController = TextEditingController();
  final densityController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();
  final windLoadController = TextEditingController();
  final foundationDiameterController = TextEditingController();
  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  String material = "Grain";
  String structureType = "Concrete";
  String foundationType = "Raft";
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  void dispose() {
    siloNameController.dispose();
    locationController.dispose();
    heightController.dispose();
    diameterController.dispose();
    thicknessController.dispose();
    hopperAngleController.dispose();
    capacityController.dispose();
    densityController.dispose();
    concreteGradeController.dispose();
    steelGradeController.dispose();
    windLoadController.dispose();
    foundationDiameterController.dispose();
    foundationDepthController.dispose();
    soilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Silo Design"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Unit Switcher in AppBar
          Obx(
            () => DropdownButton<String>(
              value: controller.selectedUnit.value,
              underline: const SizedBox(),
              items: ["meter", "feet", "inch", "centimeter"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => controller.selectedUnit.value = v!,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue, accentBlue2],
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
              child: Obx(() {
                // Reactive Unit Strings
                bool isImperial =
                    controller.selectedUnit.value == "feet" ||
                    controller.selectedUnit.value == "inch";
                String u = isImperial ? "ft" : "m";
                String sm = isImperial ? "in" : "mm";
                String densityU = isImperial ? "lb/ft³" : "kg/m³";
                String soilU = isImperial ? "psf" : "kN/m²";

                return isDesktop
                    ? _desktopLayout(u, sm, densityU, soilU)
                    : SingleChildScrollView(
                        child: _mobileLayout(u, sm, densityU, soilU),
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout(String u, String sm, String dU, String sU) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row([
            _cell("Silo Name", siloNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cell("Height", heightController, suffix: u),
            _cell("Diameter", diameterController, suffix: u),
          ]),
          _divider(),
          _row([
            _cell("Thickness", thicknessController, suffix: sm),
            _cell("Hopper Angle", hopperAngleController, suffix: "°"),
            _cellDrop("Material", material, [
              "Grain",
              "Cement",
              "Coal",
              "Sand",
            ], (v) => setState(() => material = v!)),
            _cell("Capacity", capacityController, suffix: "m³"),
          ]),
          _divider(),
          _row([
            _cell("Density", densityController, suffix: dU),
            _cellDrop("Structure", structureType, [
              "Concrete",
              "Steel",
            ], (v) => setState(() => structureType = v!)),
            _cell("Concrete Grade", concreteGradeController),
            _cell("Steel Grade", steelGradeController),
          ]),
          _divider(),
          _row([
            _cell("Wind Load", windLoadController, suffix: "kN/m²"),
            _cellDrop("Foundation", foundationType, [
              "Raft",
              "Circular Footing",
              "Pile",
            ], (v) => setState(() => foundationType = v!)),
            _cell("Found. Dia", foundationDiameterController, suffix: u),
            _cell("Found. Depth", foundationDepthController, suffix: u),
          ]),
          _divider(),
          _row([
            _cell("Soil Capacity", soilController, suffix: sU),
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

  // ================= MOBILE =================
  Widget _mobileLayout(String u, String sm, String dU, String sU) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _mobileField("Silo Name", siloNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Height", heightController, suffix: u),
          _mobileField("Diameter", diameterController, suffix: u),
          _mobileField("Thickness", thicknessController, suffix: sm),
          _mobileField("Hopper Angle", hopperAngleController, suffix: "°"),
          _mobileDrop("Material", material, [
            "Grain",
            "Cement",
            "Coal",
            "Sand",
          ], (v) => setState(() => material = v!)),
          _mobileField("Capacity", capacityController, suffix: "m³"),
          _mobileField("Density", densityController, suffix: dU),
          _mobileDrop("Structure", structureType, [
            "Concrete",
            "Steel",
          ], (v) => setState(() => structureType = v!)),
          _mobileField("Concrete Grade", concreteGradeController),
          _mobileField("Steel Grade", steelGradeController),
          _mobileField("Wind Load", windLoadController),
          _mobileDrop("Foundation", foundationType, [
            "Raft",
            "Circular Footing",
            "Pile",
          ], (v) => setState(() => foundationType = v!)),
          _mobileField(
            "Foundation Dia",
            foundationDiameterController,
            suffix: u,
          ),
          _mobileField(
            "Foundation Depth",
            foundationDepthController,
            suffix: u,
          ),
          _mobileField("Soil Capacity", soilController, suffix: sU),
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

  // ================= BUTTON =================
  Widget _submitButton() {
    return SizedBox(
      height: 45,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
        onPressed: isLoading ? null : _handleSubmit,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text("Generate Silo Drawing"),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      "unitSystem": controller.selectedUnit.value,
      "project": {
        "name": siloNameController.text,
        "location": locationController.text,
      },
      "geometry": {
        "height": heightController.text,
        "diameter": diameterController.text,
        "thickness": thicknessController.text,
        "hopperAngle": hopperAngleController.text,
      },
      "storage": {
        "material": material,
        "capacity": capacityController.text,
        "density": densityController.text,
      },
      "structure": {
        "type": structureType,
        "concreteGrade": concreteGradeController.text,
        "steelGrade": steelGradeController.text,
        "windLoad": windLoadController.text,
      },
      "foundation": {
        "type": foundationType,
        "diameter": foundationDiameterController.text,
        "depth": foundationDepthController.text,
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
        type: "silo",
        inputData: data,
      );
      Get.snackbar(
        res["success"] == true ? "Success" : "Error",
        res["message"] ?? "Complete",
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

  // ================= HELPERS =================
  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(
    String label,
    TextEditingController c, {
    bool isNumber = true,
    String suffix = "",
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            suffixText: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
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
        padding: const EdgeInsets.all(8),
        child: DropdownButtonFormField<String>(
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
          decoration: InputDecoration(
            labelText: label,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }

  Widget _mobileField(
    String label,
    TextEditingController c, {
    bool isNumber = true,
    String suffix = "",
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

  Widget _mobileDrop(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade200, height: 1);
}
