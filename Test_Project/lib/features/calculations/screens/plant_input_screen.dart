import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class PlantInputScreen extends StatefulWidget {
  const PlantInputScreen({super.key});

  @override
  State<PlantInputScreen> createState() => _PlantInputScreenState();
}

class _PlantInputScreenState extends State<PlantInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS (UNCHANGED)
  final plantNameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();

  final siteLengthController = TextEditingController();
  final siteWidthController = TextEditingController();

  final productionAreaController = TextEditingController();
  final utilityAreaController = TextEditingController();
  final storageAreaController = TextEditingController();
  final controlRoomController = TextEditingController();

  final equipmentCountController = TextEditingController();
  final equipmentSpacingController = TextEditingController();
  final craneCapacityController = TextEditingController();

  final buildingHeightController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final floorLoadController = TextEditingController();

  final pipelineWidthController = TextEditingController();
  final internalRoadController = TextEditingController();
  final serviceRoadsController = TextEditingController();

  String orientation = "North";
  String materialType = "Steel";

  String scale = "1:200";
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
        title: const Text("Industrial Plant Design"),
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
            _cell("Plant Name", plantNameController, isNumber: false),
            _cell("Industry", industryController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cell("Site Length", siteLengthController),
          ]),
          _divider(),

          _row([
            _cell("Site Width", siteWidthController),
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _cell("Production Area", productionAreaController),
            _cell("Utility Area", utilityAreaController),
          ]),
          _divider(),

          _row([
            _cell("Storage Area", storageAreaController),
            _cell("Control Room", controlRoomController),
            _cell("Equipment Count", equipmentCountController),
            _cell("Equipment Spacing", equipmentSpacingController),
          ]),
          _divider(),

          _row([
            _cell("Crane Capacity", craneCapacityController),
            _cell("Building Height", buildingHeightController),
            _cell("Column Spacing", columnSpacingController),
            _cell("Floor Load", floorLoadController),
          ]),
          _divider(),

          _row([
            _cellDrop("Material", materialType, [
              "Steel",
              "Concrete",
            ], (v) => setState(() => materialType = v!)),
            _cell("Pipeline Width", pipelineWidthController),
            _cell("Internal Road", internalRoadController),
            _cell("Service Roads", serviceRoadsController),
          ]),
          _divider(),

          _row([
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
          _mobileField("Plant Name", plantNameController, isNumber: false),
          _mobileField("Industry", industryController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Site Length", siteLengthController),
          _mobileField("Site Width", siteWidthController),
          _mobileDrop("Orientation", orientation, [
            "North",
            "South",
            "East",
            "West",
          ], (v) => setState(() => orientation = v!)),
          _mobileField("Production Area", productionAreaController),
          _mobileField("Utility Area", utilityAreaController),
          _mobileField("Storage Area", storageAreaController),
          _mobileField("Control Room", controlRoomController),
          _mobileField("Equipment Count", equipmentCountController),
          _mobileField("Equipment Spacing", equipmentSpacingController),
          _mobileField("Crane Capacity", craneCapacityController),
          _mobileField("Building Height", buildingHeightController),
          _mobileField("Column Spacing", columnSpacingController),
          _mobileField("Floor Load", floorLoadController),
          _mobileDrop("Material", materialType, [
            "Steel",
            "Concrete",
          ], (v) => setState(() => materialType = v!)),
          _mobileField("Pipeline Width", pipelineWidthController),
          _mobileField("Internal Road", internalRoadController),
          _mobileField("Service Roads", serviceRoadsController),
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
                    "name": plantNameController.text,
                    "industry": industryController.text,
                    "location": locationController.text,
                  },
                  "site": {
                    "length": siteLengthController.text,
                    "width": siteWidthController.text,
                    "orientation": orientation,
                  },
                  "layout": {
                    "productionArea": productionAreaController.text,
                    "utilityArea": utilityAreaController.text,
                    "storageArea": storageAreaController.text,
                    "controlRoom": controlRoomController.text,
                  },
                  "equipment": {
                    "count": equipmentCountController.text,
                    "spacing": equipmentSpacingController.text,
                    "craneCapacity": craneCapacityController.text,
                  },
                  "structure": {
                    "height": buildingHeightController.text,
                    "columnSpacing": columnSpacingController.text,
                    "floorLoad": floorLoadController.text,
                    "material": materialType,
                  },
                  "utilities": {
                    "pipelineWidth": pipelineWidthController.text,
                    "internalRoad": internalRoadController.text,
                    "serviceRoads": serviceRoadsController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "plant",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  if (response["success"] == true) {
                    Get.snackbar(
                      "Success",
                      response["message"] ?? "Drawing generated successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      response["message"] ?? "Something went wrong",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
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
            : const Text("Generate Plant Layout"),
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
