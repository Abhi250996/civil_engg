import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class RetainingWallInputScreen extends StatefulWidget {
  const RetainingWallInputScreen({super.key});

  @override
  State<RetainingWallInputScreen> createState() =>
      _RetainingWallInputScreenState();
}

class _RetainingWallInputScreenState extends State<RetainingWallInputScreen> {
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

  final heightController = TextEditingController();
  final lengthController = TextEditingController();
  final baseWidthController = TextEditingController();
  final stemThicknessController = TextEditingController();

  final soilWeightController = TextEditingController();
  final frictionController = TextEditingController();
  final soilBearingController = TextEditingController();

  final drainSpacingController = TextEditingController();
  final filterThicknessController = TextEditingController();

  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();
  final seismicZoneController = TextEditingController();

  String wallType = "Cantilever Wall";
  String drainType = "Weep Holes";

  String scale = "1:50";
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
        title: const Text("Retaining Wall Design"),
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
            _cell("Project Name", projectNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cell("Height", heightController),
            _cell("Length", lengthController),
          ]),
          _divider(),

          _row([
            _cell("Base Width", baseWidthController),
            _cell("Stem Thickness", stemThicknessController),
            _cellDrop("Wall Type", wallType, [
              "Cantilever Wall",
              "Gravity Wall",
              "Counterfort Wall",
              "Gabion Wall",
            ], (v) => setState(() => wallType = v!)),
            _cell("Soil Weight", soilWeightController),
          ]),
          _divider(),

          _row([
            _cell("Friction Angle", frictionController),
            _cell("Bearing Capacity", soilBearingController),
            _cellDrop("Drain Type", drainType, [
              "Weep Holes",
              "Drain Pipe",
            ], (v) => setState(() => drainType = v!)),
            _cell("Drain Spacing", drainSpacingController),
          ]),
          _divider(),

          _row([
            _cell("Filter Thickness", filterThicknessController),
            _cell("Concrete Grade", concreteGradeController),
            _cell("Steel Grade", steelGradeController),
            _cell("Seismic Zone", seismicZoneController),
          ]),
          _divider(),

          _row([
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
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _mobileField("Project Name", projectNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Height", heightController),
          _mobileField("Length", lengthController),
          _mobileField("Base Width", baseWidthController),
          _mobileField("Stem Thickness", stemThicknessController),
          _mobileDrop("Wall Type", wallType, [
            "Cantilever Wall",
            "Gravity Wall",
            "Counterfort Wall",
            "Gabion Wall",
          ], (v) => setState(() => wallType = v!)),
          _mobileField("Soil Weight", soilWeightController),
          _mobileField("Friction Angle", frictionController),
          _mobileField("Bearing Capacity", soilBearingController),
          _mobileDrop("Drain Type", drainType, [
            "Weep Holes",
            "Drain Pipe",
          ], (v) => setState(() => drainType = v!)),
          _mobileField("Drain Spacing", drainSpacingController),
          _mobileField("Filter Thickness", filterThicknessController),
          _mobileField("Concrete Grade", concreteGradeController),
          _mobileField("Steel Grade", steelGradeController),
          _mobileField("Seismic Zone", seismicZoneController),
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

                Map<String, dynamic> data = {
                  "project": {
                    "name": projectNameController.text,
                    "location": locationController.text,
                  },
                  "geometry": {
                    "height": heightController.text,
                    "length": lengthController.text,
                    "baseWidth": baseWidthController.text,
                    "stemThickness": stemThicknessController.text,
                  },
                  "wall": {"type": wallType},
                  "soil": {
                    "unitWeight": soilWeightController.text,
                    "frictionAngle": frictionController.text,
                    "bearingCapacity": soilBearingController.text,
                  },
                  "drainage": {
                    "type": drainType,
                    "spacing": drainSpacingController.text,
                    "filterThickness": filterThicknessController.text,
                  },
                  "structure": {
                    "concreteGrade": concreteGradeController.text,
                    "steelGrade": steelGradeController.text,
                    "seismicZone": seismicZoneController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "retaining_wall",
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
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text("Generate Retaining Wall Drawing"),
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
