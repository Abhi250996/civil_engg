import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class WarehouseInputScreen extends StatefulWidget {
  const WarehouseInputScreen({super.key});

  @override
  State<WarehouseInputScreen> createState() => _WarehouseInputScreenState();
}

class _WarehouseInputScreenState extends State<WarehouseInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// 📏 UNIT SYSTEM
  String selectedUnit = "meter";
  final List<String> unitOptions = [
    "feet",
    "inch",
    "centimeter",
    "yard",
    "meter",
  ];

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final columnSpacingController = TextEditingController();
  final rackHeightController = TextEditingController();
  final aisleWidthController = TextEditingController();
  final floorLoadController = TextEditingController();

  @override
  void dispose() {
    for (var c in [
      projectNameController,
      lengthController,
      widthController,
      heightController,
      columnSpacingController,
      rackHeightController,
      aisleWidthController,
      floorLoadController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Warehouse Design Panel",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
        actions: [_unitPicker(), const SizedBox(width: 15)],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, secondaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.98),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel("Project Identity"),
                    _inputField(
                      "Project Name / File ID",
                      projectNameController,
                      isNumber: false,
                    ),

                    _divider(),
                    _sectionLabel("Structural Dimensions"),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField("Total Length", lengthController),
                        ),
                        Expanded(
                          child: _inputField("Total Width", widthController),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField("Eave Height", heightController),
                        ),
                        Expanded(
                          child: _inputField(
                            "Column Spacing",
                            columnSpacingController,
                          ),
                        ),
                      ],
                    ),

                    _divider(),
                    _sectionLabel("Internal Logistics"),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            "Max Rack Height",
                            rackHeightController,
                          ),
                        ),
                        Expanded(
                          child: _inputField(
                            "Aisle Clearance",
                            aisleWidthController,
                          ),
                        ),
                      ],
                    ),
                    _inputField(
                      "Floor Load Capacity (kN/sq $selectedUnit)",
                      floorLoadController,
                    ),

                    const SizedBox(height: 40),
                    Center(child: _submitBtn()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _unitPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryBlue.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedUnit,
          items: unitOptions
              .map(
                (u) => DropdownMenuItem(
                  value: u,
                  child: Text(
                    u.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedUnit = v!),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController c, {
    bool isNumber = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          suffixText: isNumber ? selectedUnit : null,
          suffixStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Divider(color: Colors.grey.shade100, thickness: 1.5),
  );

  Widget _submitBtn() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: isLoading ? null : _processData,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                "GENERATE WAREHOUSE BLUEPRINT",
                style: TextStyle(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  void _processData() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final Map<String, dynamic> exportData = {
      "config": {
        "active_unit": selectedUnit,
        "timestamp": DateTime.now().toIso8601String(),
      },
      "project_info": {"name": projectNameController.text},
      "measurements": {
        "length": lengthController.text,
        "width": widthController.text,
        "height": heightController.text,
        "spacing": columnSpacingController.text,
      },
      "logistics": {
        "rack_height": rackHeightController.text,
        "aisle_width": aisleWidthController.text,
        "floor_load": floorLoadController.text,
      },
    };

    try {
      await controller.generateDrawingFromInputs(
        type: "warehouse",
        inputData: exportData,
      );
      Get.snackbar(
        "Success",
        "Generating drawing using $selectedUnit units",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Check your inputs and unit settings",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
