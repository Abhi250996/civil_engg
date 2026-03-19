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

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS (UNCHANGED)
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
    final args = Get.arguments ?? {};
    final project = args['project'];

    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Silo Design"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
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
            _cell("Height", heightController),
            _cell("Diameter", diameterController),
          ]),
          _divider(),

          _row([
            _cell("Thickness", thicknessController),
            _cell("Hopper Angle", hopperAngleController),
            _cellDrop("Material", material, [
              "Grain",
              "Cement",
              "Coal",
              "Sand",
            ], (v) => setState(() => material = v!)),
            _cell("Capacity", capacityController),
          ]),
          _divider(),

          _row([
            _cell("Density", densityController),
            _cellDrop("Structure", structureType, [
              "Concrete",
              "Steel",
            ], (v) => setState(() => structureType = v!)),
            _cell("Concrete Grade", concreteGradeController),
            _cell("Steel Grade", steelGradeController),
          ]),
          _divider(),

          _row([
            _cell("Wind Load", windLoadController),
            _cellDrop("Foundation", foundationType, [
              "Raft",
              "Circular Footing",
              "Pile",
            ], (v) => setState(() => foundationType = v!)),
            _cell("Foundation Dia", foundationDiameterController),
            _cell("Foundation Depth", foundationDepthController),
          ]),
          _divider(),

          _row([
            _cell("Soil", soilController),
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
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _mobileField("Silo Name", siloNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Height", heightController),
          _mobileField("Diameter", diameterController),
          _mobileField("Thickness", thicknessController),
          _mobileField("Hopper Angle", hopperAngleController),
          _mobileDrop("Material", material, [
            "Grain",
            "Cement",
            "Coal",
            "Sand",
          ], (v) => setState(() => material = v!)),
          _mobileField("Capacity", capacityController),
          _mobileField("Density", densityController),
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
          _mobileField("Foundation Dia", foundationDiameterController),
          _mobileField("Foundation Depth", foundationDepthController),
          _mobileField("Soil", soilController),
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

  // ================= BUTTON (UNCHANGED) =================
  Widget _submitButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

                final data = {
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
            : const Text("Generate Silo Drawing"),
      ),
    );
  }

  // ================= COMMON =================
  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c, {bool isNumber = true}) {
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
        child: DropdownButtonFormField<String>(
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
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
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

  Widget _divider() => Divider(color: Colors.grey.shade200);
}
