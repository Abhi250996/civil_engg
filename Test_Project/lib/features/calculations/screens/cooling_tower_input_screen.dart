import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class CoolingTowerInputScreen extends StatefulWidget {
  const CoolingTowerInputScreen({super.key});

  @override
  State<CoolingTowerInputScreen> createState() =>
      _CoolingTowerInputScreenState();
}

class _CoolingTowerInputScreenState extends State<CoolingTowerInputScreen> {
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
  final throatDiameterController = TextEditingController();
  final topDiameterController = TextEditingController();
  final shellThicknessController = TextEditingController();

  final waterFlowController = TextEditingController();
  final inletTempController = TextEditingController();
  final outletTempController = TextEditingController();
  final airFlowController = TextEditingController();

  final fanDiameterController = TextEditingController();
  final fanCountController = TextEditingController();
  final fillHeightController = TextEditingController();

  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final soilController = TextEditingController();
  final concreteGradeController = TextEditingController();
  final steelGradeController = TextEditingController();

  String towerType = "Natural Draft";

  String scale = "1:100";
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
    final args = Get.arguments ?? {};
    final project = args['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Cooling Tower Design"),
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Project: ${project?.name ?? "Unnamed"}"),
            ),
          ),
          _divider(),

          _row([
            _cell("Height", heightController),
            _cell("Base Dia", baseDiameterController),
            _cell("Throat Dia", throatDiameterController),
            _cell("Top Dia", topDiameterController),
          ]),
          _divider(),

          _row([
            _cell("Thickness", shellThicknessController),
            _cell("Water Flow", waterFlowController),
            _cell("Inlet Temp", inletTempController),
            _cell("Outlet Temp", outletTempController),
          ]),
          _divider(),

          _row([
            _cell("Air Flow", airFlowController),
            _cellDrop("Tower Type", towerType, [
              "Natural Draft",
              "Mechanical Draft",
            ], (v) => setState(() => towerType = v!)),
            _cell("Fan Dia", fanDiameterController),
            _cell("Fan Count", fanCountController),
          ]),
          _divider(),

          _row([
            _cell("Fill Height", fillHeightController),
            _cell("Concrete", concreteGradeController),
            _cell("Steel", steelGradeController),
            _cell("Wind Load", windLoadController),
          ]),
          _divider(),

          _row([
            _cell("Seismic", seismicZoneController),
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
          _mobileField("Height", heightController),
          _mobileField("Base Dia", baseDiameterController),
          _mobileField("Throat Dia", throatDiameterController),
          _mobileField("Top Dia", topDiameterController),
          _mobileField("Thickness", shellThicknessController),
          _mobileField("Water Flow", waterFlowController),
          _mobileField("Inlet Temp", inletTempController),
          _mobileField("Outlet Temp", outletTempController),
          _mobileField("Air Flow", airFlowController),
          _mobileDrop("Tower Type", towerType, [
            "Natural Draft",
            "Mechanical Draft",
          ], (v) => setState(() => towerType = v!)),
          _mobileField("Fan Dia", fanDiameterController),
          _mobileField("Fan Count", fanCountController),
          _mobileField("Fill Height", fillHeightController),
          _mobileField("Concrete", concreteGradeController),
          _mobileField("Steel", steelGradeController),
          _mobileField("Wind Load", windLoadController),
          _mobileField("Seismic", seismicZoneController),
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
                    "throatDiameter": throatDiameterController.text,
                    "topDiameter": topDiameterController.text,
                    "shellThickness": shellThicknessController.text,
                  },
                  "thermal": {
                    "waterFlow": waterFlowController.text,
                    "inletTemp": inletTempController.text,
                    "outletTemp": outletTempController.text,
                    "airFlow": airFlowController.text,
                  },
                  "mechanical": {
                    "towerType": towerType,
                    "fanDiameter": fanDiameterController.text,
                    "fanCount": fanCountController.text,
                    "fillHeight": fillHeightController.text,
                  },
                  "structure": {
                    "windLoad": windLoadController.text,
                    "seismicZone": seismicZoneController.text,
                    "soilBearingCapacity": soilController.text,
                    "concreteGrade": concreteGradeController.text,
                    "steelGrade": steelGradeController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "cooling_tower",
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
            : const Text("Generate Cooling Tower Drawing"),
      ),
    );
  }
}
