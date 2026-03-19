import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class DamInputScreen extends StatefulWidget {
  const DamInputScreen({super.key});

  @override
  State<DamInputScreen> createState() => _DamInputScreenState();
}

class _DamInputScreenState extends State<DamInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 SAME COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final damNameController = TextEditingController();
  final riverController = TextEditingController();
  final locationController = TextEditingController();

  final heightController = TextEditingController();
  final crestLengthController = TextEditingController();
  final crestWidthController = TextEditingController();
  final baseWidthController = TextEditingController();

  final reservoirCapacityController = TextEditingController();
  final maxWaterLevelController = TextEditingController();
  final minWaterLevelController = TextEditingController();

  final spillwayWidthController = TextEditingController();
  final spillwayGatesController = TextEditingController();
  final floodDischargeController = TextEditingController();

  final concreteGradeController = TextEditingController();
  final soilController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final upliftController = TextEditingController();

  String damType = "Gravity Dam";

  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  /// RESPONSIVE (NOT REMOVED)
  int getCrossAxisCount(double width) {
    if (width > 1200) return 5;
    if (width > 800) return 3;
    return 2;
  }

  Widget responsiveGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: getCrossAxisCount(constraints.maxWidth),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Dam Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
          /// PROJECT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Project: ${project?.name ?? "Unnamed"}"),
            ),
          ),
          _divider(),

          _row([
            _cell("Dam Name", damNameController, isNumber: false),
            _cell("River", riverController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cellDrop("Type", damType, [
              "Gravity Dam",
              "Arch Dam",
              "Earthfill Dam",
              "Rockfill Dam",
            ], (v) => setState(() => damType = v!)),
          ]),
          _divider(),

          _row([
            _cell("Height", heightController),
            _cell("Crest Length", crestLengthController),
            _cell("Crest Width", crestWidthController),
            _cell("Base Width", baseWidthController),
          ]),
          _divider(),

          _row([
            _cell("Capacity", reservoirCapacityController),
            _cell("Max WL", maxWaterLevelController),
            _cell("Min WL", minWaterLevelController),
            _cell("Spillway Width", spillwayWidthController),
          ]),
          _divider(),

          _row([
            _cell("Gates", spillwayGatesController),
            _cell("Discharge", floodDischargeController),
            _cell("Concrete", concreteGradeController, isNumber: false),
            _cell("Soil", soilController),
          ]),
          _divider(),

          _row([
            _cell("Seismic", seismicZoneController, isNumber: false),
            _cell("Uplift", upliftController),
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
            child: Text("Project: ${project?.name ?? "Unnamed"}"),
          ),
          _mobileField("Dam Name", damNameController, isNumber: false),
          _mobileField("River", riverController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileDrop("Type", damType, [
            "Gravity Dam",
            "Arch Dam",
            "Earthfill Dam",
            "Rockfill Dam",
          ], (v) => setState(() => damType = v!)),
          _mobileField("Height", heightController),
          _mobileField("Crest Length", crestLengthController),
          _mobileField("Crest Width", crestWidthController),
          _mobileField("Base Width", baseWidthController),
          _mobileField("Capacity", reservoirCapacityController),
          _mobileField("Max WL", maxWaterLevelController),
          _mobileField("Min WL", minWaterLevelController),
          _mobileField("Spillway Width", spillwayWidthController),
          _mobileField("Gates", spillwayGatesController),
          _mobileField("Discharge", floodDischargeController),
          _mobileField("Concrete", concreteGradeController, isNumber: false),
          _mobileField("Soil", soilController),
          _mobileField("Seismic", seismicZoneController, isNumber: false),
          _mobileField("Uplift", upliftController),
          _mobileDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
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
        onPressed: isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

                final data = {
                  "project": {
                    "damName": damNameController.text,
                    "river": riverController.text,
                    "location": locationController.text,
                  },
                  "geometry": {
                    "damType": damType,
                    "height": heightController.text,
                    "crestLength": crestLengthController.text,
                    "crestWidth": crestWidthController.text,
                    "baseWidth": baseWidthController.text,
                  },
                  "reservoir": {
                    "capacity": reservoirCapacityController.text,
                    "maxLevel": maxWaterLevelController.text,
                    "minLevel": minWaterLevelController.text,
                  },
                  "spillway": {
                    "width": spillwayWidthController.text,
                    "gates": spillwayGatesController.text,
                    "discharge": floodDischargeController.text,
                  },
                  "structure": {
                    "concreteGrade": concreteGradeController.text,
                    "soilBearingCapacity": soilController.text,
                    "seismicZone": seismicZoneController.text,
                    "uplift": upliftController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final res = await controller.generateDrawingFromInputs(
                    type: "dam",
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
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Dam Drawing"),
      ),
    );
  }
}
