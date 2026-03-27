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

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// UNIT OPTIONS
  final List<String> lengthUnits = ["m", "ft"];
  final List<String> capacityUnits = ["m³", "MCM", "AF"];
  final List<String> dischargeUnits = ["m³/s", "cusecs"];
  final List<String> pressureUnits = ["kN/m²", "psi"];

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

  /// UNIT STATES
  String heightUnit = "m";
  String capacityUnit = "MCM";
  String dischargeUnit = "m³/s";
  String pressureUnit = "kN/m²";

  String damType = "Gravity Dam";
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Dam Design & Analysis"),
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
          _cell("Dam Name", damNameController, isNumber: false),
          _cell("River / Basin", riverController, isNumber: false),
          _cell("Location", locationController, isNumber: false),
          _cellDrop("Dam Type", damType, [
            "Gravity Dam",
            "Arch Dam",
            "Earthfill Dam",
            "Rockfill Dam",
          ], (v) => setState(() => damType = v!)),
        ]),
        _divider(),
        _sectionTitle("Geometry & Dimensions"),
        _row([
          _cellWithUnit(
            "Max Height",
            heightController,
            heightUnit,
            (v) => setState(() => heightUnit = v!),
            lengthUnits,
          ),
          _cellWithUnit(
            "Crest Length",
            crestLengthController,
            heightUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Crest Width",
            crestWidthController,
            heightUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Base Width",
            baseWidthController,
            heightUnit,
            null,
            lengthUnits,
          ),
        ]),
        _divider(),
        _sectionTitle("Hydrology & Reservoir"),
        _row([
          _cellWithUnit(
            "Capacity",
            reservoirCapacityController,
            capacityUnit,
            (v) => setState(() => capacityUnit = v!),
            capacityUnits,
          ),
          _cellWithUnit(
            "Max Water Level",
            maxWaterLevelController,
            heightUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Min Water Level",
            minWaterLevelController,
            heightUnit,
            null,
            lengthUnits,
          ),
          _cellWithUnit(
            "Design Discharge",
            floodDischargeController,
            dischargeUnit,
            (v) => setState(() => dischargeUnit = v!),
            dischargeUnits,
          ),
        ]),
        _divider(),
        _sectionTitle("Structural & Material Specs"),
        _row([
          _cellWithUnit(
            "Spillway Width",
            spillwayWidthController,
            heightUnit,
            null,
            lengthUnits,
          ),
          _cell("No. of Gates", spillwayGatesController),
          _cell("Concrete Grade", concreteGradeController, isNumber: false),
          _cellWithUnit(
            "Soil Bearing",
            soilController,
            pressureUnit,
            (v) => setState(() => pressureUnit = v!),
            pressureUnits,
          ),
        ]),
        _divider(),
        _sectionTitle("Geotechnical & Analysis Settings"),
        _row([
          _cell("Seismic Zone", seismicZoneController, isNumber: false),
          _cell("Uplift Factor", upliftController),
          _cellDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
          ], (v) => setState(() => scale = v!)),
          _cellDrop("Detail Level", detailLevel, [
            "Concept",
            "Standard",
            "Construction",
          ], (v) => setState(() => detailLevel = v!)),
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
        _sectionTitle("Basic Data"),
        _mobileField("Dam Name", damNameController, isNumber: false),
        _mobileDrop("Type", damType, [
          "Gravity Dam",
          "Arch Dam",
          "Earthfill",
        ], (v) => setState(() => damType = v!)),
        _sectionTitle("Geometry"),
        _mobileWithUnit(
          "Height",
          heightController,
          heightUnit,
          (v) => setState(() => heightUnit = v!),
          lengthUnits,
        ),
        _mobileWithUnit(
          "Base Width",
          baseWidthController,
          heightUnit,
          null,
          lengthUnits,
        ),
        _sectionTitle("Reservoir"),
        _mobileWithUnit(
          "Capacity",
          reservoirCapacityController,
          capacityUnit,
          (v) => setState(() => capacityUnit = v!),
          capacityUnits,
        ),
        _mobileWithUnit(
          "Discharge",
          floodDischargeController,
          dischargeUnit,
          (v) => setState(() => dischargeUnit = v!),
          dischargeUnits,
        ),
        _sectionTitle("Blueprint"),
        _mobileDrop("Scale", scale, [
          "1:100",
          "1:200",
          "1:500",
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
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Generate Dam Drawing",
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
        "name": damNameController.text,
        "river": riverController.text,
        "location": locationController.text,
      },
      "geometry": {
        "damType": damType,
        "height": {"val": heightController.text, "unit": heightUnit},
        "crestLength": {"val": crestLengthController.text, "unit": heightUnit},
        "crestWidth": {"val": crestWidthController.text, "unit": heightUnit},
        "baseWidth": {"val": baseWidthController.text, "unit": heightUnit},
      },
      "hydrology": {
        "capacity": {
          "val": reservoirCapacityController.text,
          "unit": capacityUnit,
        },
        "maxWaterLevel": {
          "val": maxWaterLevelController.text,
          "unit": heightUnit,
        },
        "minWaterLevel": {
          "val": minWaterLevelController.text,
          "unit": heightUnit,
        },
        "designDischarge": {
          "val": floodDischargeController.text,
          "unit": dischargeUnit,
        },
      },
      "structural": {
        "spillwayWidth": spillwayWidthController.text,
        "spillwayGates": spillwayGatesController.text,
        "concreteGrade": concreteGradeController.text,
        "soilCapacity": {"val": soilController.text, "unit": pressureUnit},
        "seismicZone": seismicZoneController.text,
        "upliftFactor": upliftController.text,
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
      Get.snackbar(
        "Success",
        "Dam analysis and blueprint generated",
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
