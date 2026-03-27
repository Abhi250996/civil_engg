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

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS
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

  /// STATES
  String orientation = "North";
  String materialType = "Steel";
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Industrial Plant Design"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, secondaryBlue, bgColor],
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
                  ? SingleChildScrollView(child: _desktopLayout(project))
                  : SingleChildScrollView(child: _mobileLayout(project)),
            ),
          ),
        ),
      ),
    );
  }

  // ─── DESKTOP ──────────────────────────────────────────
  Widget _desktopLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          _sectionHeader("General & Site Info"),
          _row([
            _cell("Plant Name", plantNameController, isNumber: false),
            _cell("Industry", industryController, isNumber: false),
            _cell("Site Length (m)", siteLengthController),
            _cell("Site Width (m)", siteWidthController),
          ]),
          _divider(),
          _sectionHeader("Area Allocation"),
          _row([
            _cell("Production Area (m²)", productionAreaController),
            _cell("Utility Area (m²)", utilityAreaController),
            _cell("Storage Area (m²)", storageAreaController),
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
          ]),
          _divider(),
          _sectionHeader("Equipment & Structural"),
          _row([
            _cell("Equip. Count", equipmentCountController),
            _cell("Crane Cap. (Tons)", craneCapacityController),
            _cell("Bldg Height (m)", buildingHeightController),
            _cellDrop("Material", materialType, [
              "Steel",
              "Concrete",
            ], (v) => setState(() => materialType = v!)),
          ]),
          _divider(),
          _sectionHeader("Drawing Settings"),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: _submitButton(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── MOBILE ───────────────────────────────────────────
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _sectionHeader("General"),
          _mobileField("Plant Name", plantNameController, isNumber: false),
          _mobileField("Industry", industryController, isNumber: false),
          _sectionHeader("Site Dimensions"),
          _mobileField("Site Length", siteLengthController),
          _mobileField("Site Width", siteWidthController),
          _sectionHeader("Design Details"),
          _mobileField("Production Area", productionAreaController),
          _mobileDrop("Material", materialType, [
            "Steel",
            "Concrete",
          ], (v) => setState(() => materialType = v!)),
          _mobileDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
          ], (v) => setState(() => scale = v!)),
          const SizedBox(height: 20),
          _submitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ================= UI COMPONENTS =================

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

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
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
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
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade300, thickness: 1);

  Widget _submitButton() {
    return SizedBox(
      height: 48,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: isLoading ? null : _handleSubmission,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Generate Plant Layout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _handleSubmission() async {
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
      },
      "equipment": {
        "count": equipmentCountController.text,
        "craneCapacity": craneCapacityController.text,
      },
      "structure": {
        "height": buildingHeightController.text,
        "material": materialType,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "plant",
        inputData: data,
      );
      setState(() => isLoading = false);
      Get.snackbar(
        res["success"] ? "Success" : "Error",
        res["message"] ?? "Layout generated",
        backgroundColor: res["success"] ? Colors.green : Colors.red,
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
  }
}
