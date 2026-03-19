import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class PipelineInputScreen extends StatefulWidget {
  const PipelineInputScreen({super.key});

  @override
  State<PipelineInputScreen> createState() => _PipelineInputScreenState();
}

class _PipelineInputScreenState extends State<PipelineInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS (UNCHANGED)
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  final lengthController = TextEditingController();
  final diameterController = TextEditingController();
  final thicknessController = TextEditingController();

  final flowRateController = TextEditingController();
  final pressureController = TextEditingController();

  final startElevationController = TextEditingController();
  final endElevationController = TextEditingController();

  final valveSpacingController = TextEditingController();
  final pumpStationsController = TextEditingController();
  final supportSpacingController = TextEditingController();

  String fluidType = "Water";
  String groundType = "Soil";

  String scale = "1:500";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Pipeline Design"),
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
            _cell("Length (km)", lengthController),
            _cell("Diameter", diameterController),
          ]),
          _divider(),

          _row([
            _cell("Thickness", thicknessController),
            _cell("Flow Rate", flowRateController),
            _cell("Pressure", pressureController),
            _cellDrop("Fluid", fluidType, [
              "Water",
              "Oil",
              "Gas",
              "Chemical",
            ], (v) => setState(() => fluidType = v!)),
          ]),
          _divider(),

          _row([
            _cell("Start Elevation", startElevationController),
            _cell("End Elevation", endElevationController),
            _cellDrop("Ground", groundType, [
              "Soil",
              "Rock",
              "Mixed",
            ], (v) => setState(() => groundType = v!)),
            _cell("Valve Spacing", valveSpacingController),
          ]),
          _divider(),

          _row([
            _cell("Pump Stations", pumpStationsController),
            _cell("Support Spacing", supportSpacingController),
            _cellDrop("Scale", scale, [
              "1:200",
              "1:500",
              "1:1000",
            ], (v) => setState(() => scale = v!)),
            _cellDrop("Sheet", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
          ]),
          _divider(),

          _row([
            _cellDrop("Detail", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const Expanded(child: SizedBox()),
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
          _mobileField("Length (km)", lengthController),
          _mobileField("Diameter", diameterController),
          _mobileField("Thickness", thicknessController),
          _mobileField("Flow Rate", flowRateController),
          _mobileField("Pressure", pressureController),
          _mobileDrop("Fluid", fluidType, [
            "Water",
            "Oil",
            "Gas",
            "Chemical",
          ], (v) => setState(() => fluidType = v!)),
          _mobileField("Start Elevation", startElevationController),
          _mobileField("End Elevation", endElevationController),
          _mobileDrop("Ground", groundType, [
            "Soil",
            "Rock",
            "Mixed",
          ], (v) => setState(() => groundType = v!)),
          _mobileField("Valve Spacing", valveSpacingController),
          _mobileField("Pump Stations", pumpStationsController),
          _mobileField("Support Spacing", supportSpacingController),
          _mobileDrop("Scale", scale, [
            "1:200",
            "1:500",
            "1:1000",
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

                Map<String, dynamic> data = {
                  "project": {
                    "name": projectNameController.text,
                    "location": locationController.text,
                  },
                  "pipeline": {
                    "length": lengthController.text,
                    "diameter": diameterController.text,
                    "thickness": thicknessController.text,
                  },
                  "hydraulics": {
                    "flowRate": flowRateController.text,
                    "pressure": pressureController.text,
                    "fluid": fluidType,
                  },
                  "route": {
                    "startElevation": startElevationController.text,
                    "endElevation": endElevationController.text,
                    "ground": groundType,
                  },
                  "components": {
                    "valveSpacing": valveSpacingController.text,
                    "pumpStations": pumpStationsController.text,
                    "supportSpacing": supportSpacingController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "pipeline",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  if (response["success"] == true) {
                    Get.snackbar(
                      "Success",
                      response["message"] ?? "Drawing generated successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      response["message"] ?? "Something went wrong",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } catch (e) {
                  setState(() => isLoading = false);

                  Get.snackbar(
                    "Error",
                    e.toString(),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
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
            : const Text("Generate Pipeline Drawing"),
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
