import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class ChimneyInputScreen extends StatefulWidget {
  const ChimneyInputScreen({super.key});

  @override
  State<ChimneyInputScreen> createState() => _ChimneyInputScreenState();
}

class _ChimneyInputScreenState extends State<ChimneyInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 SAME COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final heightController = TextEditingController();
  final baseDiameterController = TextEditingController();
  final topDiameterController = TextEditingController();
  final thicknessController = TextEditingController();

  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();

  final gasTempController = TextEditingController();
  final gasVelocityController = TextEditingController();
  final liningThicknessController = TextEditingController();

  final foundationDepthController = TextEditingController();
  final foundationDiameterController = TextEditingController();
  final soilController = TextEditingController();

  String material = "Reinforced Concrete";
  String foundationType = "Circular Footing";

  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  /// ================= RESPONSIVE (NOT REMOVED) =================
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
    final Map<String, dynamic> args = Get.arguments ?? {};
    final project = args['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Chimney Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      /// 🔥 SAME GRADIENT
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
                  ? _desktopLayout(project) // ❌ NO SCROLL
                  : SingleChildScrollView(child: _mobileLayout(project)),
            ),
          ),
        ),
      ),
    );
  }

  // ─── DESKTOP (TABLE STYLE) ─────────────────────────────
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

          /// ROWS (LIKE BUILDING)
          _row([
            _cell("Height", heightController),
            _cell("Base Dia", baseDiameterController),
            _cell("Top Dia", topDiameterController),
            _cell("Thickness", thicknessController),
          ]),
          _divider(),

          _row([
            _cellDrop("Material", material, [
              "Reinforced Concrete",
              "Steel",
            ], (v) => setState(() => material = v!)),
            _cell("Wind Load", windLoadController),
            _cell("Seismic Zone", seismicZoneController),
            _cell("Concrete", concreteGradeController),
          ]),
          _divider(),

          _row([
            _cell("Steel Grade", steelGradeController),
            _cell("Gas Temp", gasTempController),
            _cell("Velocity", gasVelocityController),
            _cell("Lining", liningThicknessController),
          ]),
          _divider(),

          _row([
            _cellDrop("Foundation", foundationType, [
              "Circular Footing",
              "Raft",
              "Pile Foundation",
            ], (v) => setState(() => foundationType = v!)),
            _cell("F Dia", foundationDiameterController),
            _cell("F Depth", foundationDepthController),
            _cell("Soil", soilController),
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
          _mobileField("Height", heightController),
          _mobileField("Base Dia", baseDiameterController),
          _mobileField("Top Dia", topDiameterController),
          _mobileField("Thickness", thicknessController),
          _mobileDrop("Material", material, [
            "Reinforced Concrete",
            "Steel",
          ], (v) => setState(() => material = v!)),
          _mobileField("Wind Load", windLoadController),
          _mobileField("Seismic Zone", seismicZoneController),
          _mobileField("Concrete", concreteGradeController),
          _mobileField("Steel", steelGradeController),
          _mobileField("Gas Temp", gasTempController),
          _mobileField("Velocity", gasVelocityController),
          _mobileField("Lining", liningThicknessController),
          _mobileDrop("Foundation", foundationType, [
            "Circular Footing",
            "Raft",
            "Pile Foundation",
          ], (v) => setState(() => foundationType = v!)),
          _mobileField("F Dia", foundationDiameterController),
          _mobileField("F Depth", foundationDepthController),
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

  /// COMMON
  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
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

  Widget _mobileField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
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

  /// BUTTON (UNCHANGED)
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
                  "geometry": {
                    "height": heightController.text,
                    "baseDiameter": baseDiameterController.text,
                    "topDiameter": topDiameterController.text,
                    "thickness": thicknessController.text,
                  },
                  "structure": {
                    "material": material,
                    "windLoad": windLoadController.text,
                    "seismicZone": seismicZoneController.text,
                    "concreteGrade": concreteGradeController.text,
                    "steelGrade": steelGradeController.text,
                  },
                  "thermal": {
                    "gasTemp": gasTempController.text,
                    "gasVelocity": gasVelocityController.text,
                    "liningThickness": liningThicknessController.text,
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
                  final response = await controller.generateDrawingFromInputs(
                    type: "chimney",
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
            : const Text("Generate Chimney Drawing"),
      ),
    );
  }
}
