import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FactoryInputScreen extends StatefulWidget {
  const FactoryInputScreen({super.key});

  @override
  State<FactoryInputScreen> createState() => _FactoryInputScreenState();
}

class _FactoryInputScreenState extends State<FactoryInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 SAME COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final factoryNameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();

  final plotLengthController = TextEditingController();
  final plotWidthController = TextEditingController();
  String orientation = "North";

  final productionAreaController = TextEditingController();
  final productionLinesController = TextEditingController();
  final machineSpacingController = TextEditingController();
  final storageAreaController = TextEditingController();
  final officeAreaController = TextEditingController();

  final buildingHeightController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final floorLoadController = TextEditingController();
  String roofType = "Steel Truss";

  final loadingDocksController = TextEditingController();
  final truckAccessController = TextEditingController();
  final internalRoadController = TextEditingController();

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
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Factory Layout Design"),
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
            _cell("Factory Name", factoryNameController, isNumber: false),
            _cell("Industry", industryController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cell("Length", plotLengthController),
          ]),
          _divider(),

          _row([
            _cell("Width", plotWidthController),
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _cell("Production Area", productionAreaController),
            _cell("Lines", productionLinesController),
          ]),
          _divider(),

          _row([
            _cell("Machine Space", machineSpacingController),
            _cell("Storage", storageAreaController),
            _cell("Office", officeAreaController),
            _cell("Height", buildingHeightController),
          ]),
          _divider(),

          _row([
            _cell("Column Space", columnSpacingController),
            _cellDrop("Roof", roofType, [
              "Steel Truss",
              "RC Slab",
            ], (v) => setState(() => roofType = v!)),
            _cell("Floor Load", floorLoadController),
            _cell("Docks", loadingDocksController),
          ]),
          _divider(),

          _row([
            _cell("Truck Access", truckAccessController),
            _cell("Internal Road", internalRoadController),
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
          _mobileField("Factory Name", factoryNameController, isNumber: false),
          _mobileField("Industry", industryController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Length", plotLengthController),
          _mobileField("Width", plotWidthController),
          _mobileDrop("Orientation", orientation, [
            "North",
            "South",
            "East",
            "West",
          ], (v) => setState(() => orientation = v!)),
          _mobileField("Production Area", productionAreaController),
          _mobileField("Lines", productionLinesController),
          _mobileField("Machine Space", machineSpacingController),
          _mobileField("Storage", storageAreaController),
          _mobileField("Office", officeAreaController),
          _mobileField("Height", buildingHeightController),
          _mobileField("Column Space", columnSpacingController),
          _mobileDrop("Roof", roofType, [
            "Steel Truss",
            "RC Slab",
          ], (v) => setState(() => roofType = v!)),
          _mobileField("Floor Load", floorLoadController),
          _mobileField("Docks", loadingDocksController),
          _mobileField("Truck Access", truckAccessController),
          _mobileField("Internal Road", internalRoadController),
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
                    "factoryName": factoryNameController.text,
                    "industry": industryController.text,
                    "location": locationController.text,
                  },
                  "site": {
                    "length": plotLengthController.text,
                    "width": plotWidthController.text,
                    "orientation": orientation,
                  },
                  "layout": {
                    "productionArea": productionAreaController.text,
                    "productionLines": productionLinesController.text,
                    "machineSpacing": machineSpacingController.text,
                    "storageArea": storageAreaController.text,
                    "officeArea": officeAreaController.text,
                  },
                  "structure": {
                    "height": buildingHeightController.text,
                    "columnSpacing": columnSpacingController.text,
                    "roofType": roofType,
                    "floorLoad": floorLoadController.text,
                  },
                  "logistics": {
                    "loadingDocks": loadingDocksController.text,
                    "truckAccess": truckAccessController.text,
                    "internalRoad": internalRoadController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "factory",
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
            : const Text("Generate Factory Layout"),
      ),
    );
  }
}
