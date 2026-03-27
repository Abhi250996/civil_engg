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

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> lengthUnits = ["m", "ft"];
  final List<String> areaUnits = ["m²", "sq.ft", "acres"];
  final List<String> loadUnits = ["kN/m²", "kg/m²", "psf"];

  /// CONTROLLERS
  final factoryNameController = TextEditingController();
  final industryController = TextEditingController();
  final locationController = TextEditingController();
  final plotLengthController = TextEditingController();
  final plotWidthController = TextEditingController();
  final productionAreaController = TextEditingController();
  final productionLinesController = TextEditingController();
  final machineSpacingController = TextEditingController();
  final storageAreaController = TextEditingController();
  final officeAreaController = TextEditingController();
  final buildingHeightController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final floorLoadController = TextEditingController();
  final loadingDocksController = TextEditingController();
  final truckAccessController = TextEditingController();
  final internalRoadController = TextEditingController();

  /// UNIT STATES
  String dimUnit = "m";
  String areaUnit = "m²";
  String loadUnit = "kN/m²";

  String orientation = "North";
  String roofType = "Steel Truss";
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Factory Layout Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
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
            constraints: const BoxConstraints(maxWidth: 1400),
            padding: const EdgeInsets.all(14),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: isDesktop
                      ? _desktopLayout(project)
                      : _mobileLayout(project),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── DESKTOP ─────────────────────────────
  Widget _desktopLayout(dynamic project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("General Information - ${project?.name ?? "Unnamed"}"),
        _row([
          _cell("Factory Name", factoryNameController, isNumber: false),
          _cell("Industry Type", industryController, isNumber: false),
          _cell("Location", locationController, isNumber: false),
          _cellDrop("Orientation", orientation, [
            "North",
            "South",
            "East",
            "West",
          ], (v) => setState(() => orientation = v!)),
        ]),
        _divider(),
        _sectionTitle("Site & Production Area"),
        _row([
          _cellWithUnit(
            "Plot Length",
            plotLengthController,
            dimUnit,
            (v) => setState(() => dimUnit = v!),
            lengthUnits,
          ),
          _cellWithUnit(
            "Plot Width",
            plotWidthController,
            dimUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Prod. Area",
            productionAreaController,
            areaUnit,
            (v) => setState(() => areaUnit = v!),
            areaUnits,
          ),
          _cell("Prod. Lines", productionLinesController),
        ]),
        _divider(),
        _sectionTitle("Building & Structural Specifications"),
        _row([
          _cellWithUnit(
            "Machine Spacing",
            machineSpacingController,
            dimUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Bldg. Height",
            buildingHeightController,
            dimUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Column Space",
            columnSpacingController,
            dimUnit,
            null,
            lengthUnits,
          ),
          _cellDrop("Roof Type", roofType, [
            "Steel Truss",
            "RC Slab",
            "Sawtooth",
          ], (v) => setState(() => roofType = v!)),
        ]),
        _divider(),
        _sectionTitle("Load & Logistics"),
        _row([
          _cellWithUnit(
            "Floor Load",
            floorLoadController,
            loadUnit,
            (v) => setState(() => loadUnit = v!),
            loadUnits,
          ),
          _cell("Loading Docks", loadingDocksController),
          _cellWithUnit(
            "Truck Access",
            truckAccessController,
            dimUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Internal Road",
            internalRoadController,
            dimUnit,
            null,
            lengthUnits,
          ),
        ]),
        _divider(),
        _sectionTitle("Blueprint Settings"),
        _row([
          _cellDrop("Scale", scale, [
            "1:50",
            "1:100",
            "1:200",
          ], (v) => setState(() => scale = v!)),
          _cellDrop("Sheet Size", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _cellDrop("Detail Level", detailLevel, [
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
    );
  }

  // ─── MOBILE ─────────────────────────────
  Widget _mobileLayout(dynamic project) {
    return Column(
      children: [
        _sectionTitle("General Info"),
        _mobileField("Factory Name", factoryNameController, isNumber: false),
        _mobileField("Industry", industryController, isNumber: false),
        _sectionTitle("Production & Site"),
        _mobileWithUnit(
          "Plot Length",
          plotLengthController,
          dimUnit,
          (v) => setState(() => dimUnit = v!),
          lengthUnits,
        ),
        _mobileWithUnit(
          "Prod. Area",
          productionAreaController,
          areaUnit,
          (v) => setState(() => areaUnit = v!),
          areaUnits,
        ),
        _sectionTitle("Logistics"),
        _mobileWithUnit(
          "Floor Load",
          floorLoadController,
          loadUnit,
          (v) => setState(() => loadUnit = v!),
          loadUnits,
        ),
        _mobileDrop("Roof Type", roofType, [
          "Steel Truss",
          "RC Slab",
        ], (v) => setState(() => roofType = v!)),
        _mobileDrop("Scale", scale, [
          "1:50",
          "1:100",
          "1:200",
        ], (v) => setState(() => scale = v!)),
        const SizedBox(height: 10),
        _submitButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ================= UI HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _unitPicker(
    String currentVal,
    List<String> options,
    Function(String?)? onChanged,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentVal,
        icon: const Icon(Icons.arrow_drop_down, size: 14, color: secondaryBlue),
        style: const TextStyle(
          color: primaryBlue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        items: options
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _cellWithUnit(
    String label,
    TextEditingController c,
    String unit,
    Function(String?)? onUnitChanged,
    List<String> opts,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => v!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _unitPicker(unit, opts, onUnitChanged),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileWithUnit(
    String label,
    TextEditingController c,
    String unit,
    Function(String?)? onUnitChanged,
    List<String> opts,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _unitPicker(unit, opts, onUnitChanged),
          ),
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
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
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
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
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

  Widget _divider() => Divider(color: Colors.grey.shade300, height: 1);

  Widget _submitButton() {
    return SizedBox(
      height: 45,
      width: 280,
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
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Generate Factory Layout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      "project": {
        "name": factoryNameController.text,
        "industry": industryController.text,
        "location": locationController.text,
      },
      "site": {
        "length": plotLengthController.text,
        "width": plotWidthController.text,
        "unit": dimUnit,
        "orientation": orientation,
      },
      "requirements": {
        "productionArea": productionAreaController.text,
        "productionLines": productionLinesController.text,
        "machineSpacing": machineSpacingController.text,
        "areaUnit": areaUnit,
      },
      "structure": {
        "buildingHeight": buildingHeightController.text,
        "columnSpacing": columnSpacingController.text,
        "roofType": roofType,
        "floorLoad": floorLoadController.text,
        "loadUnit": loadUnit,
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
      final res = await controller.generateDrawingFromInputs(
        type: "factory",
        inputData: data,
      );
      Get.snackbar(
        "Success",
        "Factory blueprint generated",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
