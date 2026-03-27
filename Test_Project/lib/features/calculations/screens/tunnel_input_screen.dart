import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TunnelInputScreen extends StatefulWidget {
  const TunnelInputScreen({super.key});

  @override
  State<TunnelInputScreen> createState() => _TunnelInputScreenState();
}

class _TunnelInputScreenState extends State<TunnelInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final lengthController = TextEditingController();
  final diameterController = TextEditingController();
  final depthController = TextEditingController();
  final rockStrengthController = TextEditingController();
  final groundwaterController = TextEditingController();
  final liningThicknessController = TextEditingController();
  final rebarDiameterController = TextEditingController();
  final ventilationDiameterController = TextEditingController();
  final drainageWidthController = TextEditingController();

  String tunnelType = "Road Tunnel";
  String rockType = "Hard Rock";
  String excavationMethod = "TBM";
  String concreteGrade = "M30";
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Tunnel Design Engineering",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Form(key: formKey, child: _mainContainer(isDesktop)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainContainer(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Project & Geometry"),
          _responsiveRow(isDesktop, [
            _buildField("Project Name", projectNameController),
            _buildField("Location", locationController),
            _buildField("Length (m)", lengthController, isNumber: true),
          ]),
          _responsiveRow(isDesktop, [
            _buildField("Diameter (m)", diameterController, isNumber: true),
            _buildField("Depth (m)", depthController, isNumber: true),
            _buildDropdown("Tunnel Type", tunnelType, [
              "Road Tunnel",
              "Railway Tunnel",
              "Metro Tunnel",
              "Utility Tunnel",
            ], (v) => setState(() => tunnelType = v!)),
          ]),

          _divider(),
          _sectionTitle("Geotechnical & Excavation"),
          _responsiveRow(isDesktop, [
            _buildDropdown("Rock Type", rockType, [
              "Soft Rock",
              "Hard Rock",
              "Soil",
            ], (v) => setState(() => rockType = v!)),
            _buildField(
              "Rock Strength (MPa)",
              rockStrengthController,
              isNumber: true,
            ),
            _buildField(
              "Groundwater (m)",
              groundwaterController,
              isNumber: true,
            ),
          ]),
          _responsiveRow(isDesktop, [
            _buildDropdown(
              "Excavation Method",
              excavationMethod,
              ["TBM", "NATM", "Drill & Blast"],
              (v) => setState(() => excavationMethod = v!),
            ),
            _buildField(
              "Lining Thickness (mm)",
              liningThicknessController,
              isNumber: true,
            ),
            _buildDropdown(
              "Concrete Grade",
              concreteGrade,
              ["M25", "M30", "M35", "M40"],
              (v) => setState(() => concreteGrade = v!),
            ),
          ]),

          _divider(),
          _sectionTitle("Internal Systems & Drafting"),
          _responsiveRow(isDesktop, [
            _buildField(
              "Rebar Dia (mm)",
              rebarDiameterController,
              isNumber: true,
            ),
            _buildField(
              "Ventilation Dia (m)",
              ventilationDiameterController,
              isNumber: true,
            ),
            _buildField(
              "Drainage Width (m)",
              drainageWidthController,
              isNumber: true,
            ),
          ]),
          _responsiveRow(isDesktop, [
            _buildDropdown("Drawing Scale", scale, [
              "1:100",
              "1:200",
              "1:500",
            ], (v) => setState(() => scale = v!)),
            _buildDropdown("Sheet Size", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
            _buildDropdown("Detail Level", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
          ]),

          const SizedBox(height: 40),
          _submitButton(),
        ],
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────

  Widget _responsiveRow(bool isDesktop, List<Widget> children) {
    if (isDesktop) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map(
                (e) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: e,
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
    return Column(
      children: children
          .map(
            (e) =>
                Padding(padding: const EdgeInsets.only(bottom: 12), child: e),
          )
          .toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController c, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Divider(color: Colors.grey.shade300, thickness: 1),
  );

  Widget _submitButton() {
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
          elevation: 5,
        ),
        onPressed: _handleSubmission,
        child: const Text(
          "GENERATE TECHNICAL DRAWING",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  void _handleSubmission() {
    if (!formKey.currentState!.validate()) return;

    Map<String, dynamic> data = {
      "project": {
        "name": projectNameController.text,
        "location": locationController.text,
      },
      "geometry": {
        "length": lengthController.text,
        "diameter": diameterController.text,
        "depth": depthController.text,
        "type": tunnelType,
      },
      "geotechnical": {
        "rockType": rockType,
        "rockStrength": rockStrengthController.text,
        "groundwater": groundwaterController.text,
      },
      "excavation": {"method": excavationMethod},
      "structure": {
        "liningThickness": liningThicknessController.text,
        "concreteGrade": concreteGrade,
        "rebarDiameter": rebarDiameterController.text,
      },
      "systems": {
        "ventilationDiameter": ventilationDiameterController.text,
        "drainageWidth": drainageWidthController.text,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    controller.generateDrawingFromInputs(type: "tunnel", inputData: data);
  }
}
