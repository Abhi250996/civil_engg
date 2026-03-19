import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FoundationInputScreen extends StatefulWidget {
  const FoundationInputScreen({super.key});

  @override
  State<FoundationInputScreen> createState() => _FoundationInputScreenState();
}

class _FoundationInputScreenState extends State<FoundationInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  final floorsController = TextEditingController();
  final columnLoadController = TextEditingController();
  String structureType = "Building";

  final soilBearingController = TextEditingController();
  final waterTableController = TextEditingController();
  String soilType = "Clay";

  final footingLengthController = TextEditingController();
  final footingWidthController = TextEditingController();
  final footingThicknessController = TextEditingController();

  final columnSizeController = TextEditingController();
  final columnSpacingController = TextEditingController();

  final rebarDiameterController = TextEditingController();
  final rebarSpacingController = TextEditingController();

  String scale = "1:50";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Foundation Design"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      /// GRADIENT
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
                  ? _desktopLayout()
                  : SingleChildScrollView(child: _mobileLayout()),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout() {
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
            _cell("Project Name", projectNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cellDrop("Structure", structureType, [
              "Building",
              "Tower",
              "Bridge",
              "Industrial",
            ], (v) => setState(() => structureType = v!)),
            _cell("Floors", floorsController),
          ]),
          _divider(),

          _row([
            _cell("Column Load", columnLoadController),
            _cell("Soil Bearing", soilBearingController),
            _cell("Water Table", waterTableController),
            _cellDrop("Soil Type", soilType, [
              "Clay",
              "Sand",
              "Rock",
              "Mixed",
            ], (v) => setState(() => soilType = v!)),
          ]),
          _divider(),

          _row([
            _cell("Footing Length", footingLengthController),
            _cell("Footing Width", footingWidthController),
            _cell("Thickness", footingThicknessController),
            _cell("Column Size", columnSizeController),
          ]),
          _divider(),

          _row([
            _cell("Column Spacing", columnSpacingController),
            _cell("Rebar Dia", rebarDiameterController),
            _cell("Rebar Spacing", rebarSpacingController),
            _cellDrop("Scale", scale, [
              "1:20",
              "1:50",
              "1:100",
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
  Widget _mobileLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _mobileField("Project Name", projectNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileDrop("Structure", structureType, [
            "Building",
            "Tower",
            "Bridge",
            "Industrial",
          ], (v) => setState(() => structureType = v!)),
          _mobileField("Floors", floorsController),
          _mobileField("Column Load", columnLoadController),
          _mobileField("Soil Bearing", soilBearingController),
          _mobileField("Water Table", waterTableController),
          _mobileDrop("Soil Type", soilType, [
            "Clay",
            "Sand",
            "Rock",
            "Mixed",
          ], (v) => setState(() => soilType = v!)),
          _mobileField("Footing Length", footingLengthController),
          _mobileField("Footing Width", footingWidthController),
          _mobileField("Thickness", footingThicknessController),
          _mobileField("Column Size", columnSizeController),
          _mobileField("Column Spacing", columnSpacingController),
          _mobileField("Rebar Dia", rebarDiameterController),
          _mobileField("Rebar Spacing", rebarSpacingController),
          _mobileDrop("Scale", scale, [
            "1:20",
            "1:50",
            "1:100",
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

  // ================= BUTTON (UNCHANGED LOGIC) =================
  Widget _submitButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

                Map<String, dynamic> data = {
                  "project": {
                    "name": projectNameController.text,
                    "location": locationController.text,
                  },
                  "structure": {
                    "type": structureType,
                    "floors": floorsController.text,
                    "columnLoad": columnLoadController.text,
                  },
                  "soil": {
                    "bearingCapacity": soilBearingController.text,
                    "waterTable": waterTableController.text,
                    "type": soilType,
                  },
                  "foundation": {
                    "length": footingLengthController.text,
                    "width": footingWidthController.text,
                    "thickness": footingThicknessController.text,
                  },
                  "column": {
                    "size": columnSizeController.text,
                    "spacing": columnSpacingController.text,
                  },
                  "reinforcement": {
                    "diameter": rebarDiameterController.text,
                    "spacing": rebarSpacingController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "foundation",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  Get.snackbar(
                    response["success"] == true ? "Success" : "Error",
                    response["message"] ?? "Something went wrong",
                    backgroundColor: response["success"] == true
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
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Foundation Drawing"),
      ),
    );
  }

  /// COMMON
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
}
