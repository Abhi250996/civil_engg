import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class BuildingInputScreen extends StatefulWidget {
  const BuildingInputScreen({super.key});

  @override
  State<BuildingInputScreen> createState() => _BuildingInputScreenState();
}

class _BuildingInputScreenState extends State<BuildingInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 UI COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> unitOptions = [
    "Meter",
    "Feet",
    "Foot",
    "Inch",
    "Yard",
    "Centimeter",
  ];

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final plotLengthController = TextEditingController();
  final plotWidthController = TextEditingController();
  String orientation = "North";
  final floorsController = TextEditingController();
  final roomsController = TextEditingController();
  final floorHeightController = TextEditingController();
  final frontSetbackController = TextEditingController();
  final rearSetbackController = TextEditingController();
  final sideSetbackController = TextEditingController();
  final soilController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final designLoadController = TextEditingController();

  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  /// INDIVIDUAL UNIT STATES
  String lengthUnit = "Meter";
  String widthUnit = "Meter";
  String heightUnit = "Meter";
  String frontUnit = "Meter";
  String rearUnit = "Meter";
  String sideUnit = "Meter";
  String soilUnit = "kN/m²";
  String loadUnit = "kN/m²";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Building Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: isDesktop ? _desktopLayout() : _mobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= DESKTOP =================
  Widget _desktopLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row([
            _cell("Project Name", projectNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cellWithUnit(
              "Length",
              plotLengthController,
              lengthUnit,
              (v) => setState(() => lengthUnit = v!),
            ),
            _cellWithUnit(
              "Width",
              plotWidthController,
              widthUnit,
              (v) => setState(() => widthUnit = v!),
            ),
          ]),
          _divider(),
          _row([
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _cell("Floors", floorsController),
            _cell("Rooms", roomsController),
            _cellWithUnit(
              "Floor Height",
              floorHeightController,
              heightUnit,
              (v) => setState(() => heightUnit = v!),
            ),
          ]),
          _divider(),
          _row([
            _cellWithUnit(
              "Front Setback",
              frontSetbackController,
              frontUnit,
              (v) => setState(() => frontUnit = v!),
            ),
            _cellWithUnit(
              "Rear Setback",
              rearSetbackController,
              rearUnit,
              (v) => setState(() => rearUnit = v!),
            ),
            _cellWithUnit(
              "Side Setback",
              sideSetbackController,
              sideUnit,
              (v) => setState(() => sideUnit = v!),
            ),
            _cellWithUnit(
              "Soil SBC",
              soilController,
              soilUnit,
              (v) => setState(() => soilUnit = v!),
              customUnits: ["kN/m²", "psf"],
            ),
          ]),
          _divider(),
          _row([
            _cell("Seismic Zone", seismicZoneController),
            _cellWithUnit(
              "Design Load",
              designLoadController,
              loadUnit,
              (v) => setState(() => loadUnit = v!),
              customUnits: ["kN/m²", "psf"],
            ),
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
          ]),
          _divider(),
          _row([
            _cellDrop("Detail Level", detailLevel, [
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

  /// ================= MOBILE =================
  Widget _mobileLayout() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _mobileField(
              "Project Name",
              projectNameController,
              isNumber: false,
            ),
            _mobileField("Location", locationController, isNumber: false),
            _mobileFieldWithUnit(
              "Length",
              plotLengthController,
              lengthUnit,
              (v) => setState(() => lengthUnit = v!),
            ),
            _mobileFieldWithUnit(
              "Width",
              plotWidthController,
              widthUnit,
              (v) => setState(() => widthUnit = v!),
            ),
            _mobileDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _mobileField("Floors", floorsController),
            _mobileField("Rooms", roomsController),
            _mobileFieldWithUnit(
              "Floor Height",
              floorHeightController,
              heightUnit,
              (v) => setState(() => heightUnit = v!),
            ),
            _mobileFieldWithUnit(
              "Front Setback",
              frontSetbackController,
              frontUnit,
              (v) => setState(() => frontUnit = v!),
            ),
            _mobileFieldWithUnit(
              "Rear Setback",
              rearSetbackController,
              rearUnit,
              (v) => setState(() => rearUnit = v!),
            ),
            _mobileFieldWithUnit(
              "Side Setback",
              sideSetbackController,
              sideUnit,
              (v) => setState(() => sideUnit = v!),
            ),
            _mobileFieldWithUnit(
              "Soil SBC",
              soilController,
              soilUnit,
              (v) => setState(() => soilUnit = v!),
              customUnits: ["kN/m²", "psf"],
            ),
            _mobileField("Seismic Zone", seismicZoneController),
            _mobileFieldWithUnit(
              "Design Load",
              designLoadController,
              loadUnit,
              (v) => setState(() => loadUnit = v!),
              customUnits: ["kN/m²", "psf"],
            ),
            _mobileDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
            ], (v) => setState(() => scale = v!)),
            _mobileDrop("Sheet Size", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
            _mobileDrop("Detail Level", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const SizedBox(height: 10),
            _submitButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// ================= REUSABLE UNIT PICKER =================
  Widget _unitPicker(
    String currentVal,
    List<String> options,
    Function(String?) onChanged,
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

  /// ================= CELL HELPERS WITH UNITS =================
  Widget _cellWithUnit(
    String label,
    TextEditingController c,
    String currentUnit,
    Function(String?) onUnitChanged, {
    List<String>? customUnits,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _unitPicker(
                currentUnit,
                customUnits ?? unitOptions,
                onUnitChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileFieldWithUnit(
    String label,
    TextEditingController c,
    String currentUnit,
    Function(String?) onUnitChanged, {
    List<String>? customUnits,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _unitPicker(
              currentUnit,
              customUnits ?? unitOptions,
              onUnitChanged,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= STANDARD HELPERS =================
  Widget _row(List<Widget> children) =>
      IntrinsicHeight(child: Row(children: children));

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
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
        onPressed: isLoading ? null : _submitData,
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Building Drawing"),
      ),
    );
  }

  void _submitData() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "project": {
        "name": projectNameController.text,
        "location": locationController.text,
      },
      "site": {
        "length": plotLengthController.text,
        "length_unit": lengthUnit,
        "width": plotWidthController.text,
        "width_unit": widthUnit,
        "orientation": orientation,
      },
      "building": {
        "floors": floorsController.text,
        "rooms": roomsController.text,
        "floorHeight": floorHeightController.text,
        "height_unit": heightUnit,
      },
      "setbacks": {
        "front": frontSetbackController.text,
        "front_unit": frontUnit,
        "rear": rearSetbackController.text,
        "rear_unit": rearUnit,
        "side": sideSetbackController.text,
        "side_unit": sideUnit,
      },
      "structure": {
        "soilSBC": soilController.text,
        "soil_unit": soilUnit,
        "seismic": seismicZoneController.text,
        "designLoad": designLoadController.text,
        "load_unit": loadUnit,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "building",
        inputData: data,
      );
      setState(() => isLoading = false);
      Get.snackbar(res["success"] ? "Success" : "Error", res["message"] ?? "");
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", e.toString());
    }
  }
}
