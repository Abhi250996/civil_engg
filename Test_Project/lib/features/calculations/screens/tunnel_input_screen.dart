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

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS (UNCHANGED)
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
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Tunnel Design"),
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),

      /// 🔥 GRADIENT
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            padding: const EdgeInsets.all(20),

            child: Form(
              key: formKey,
              child: isDesktop
                  ? _desktopLayout()
                  : SingleChildScrollView(child: _mobileLayout()),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _row([
            _cell("Project Name", projectNameController, false),
            _cell("Location", locationController, false),
            _cell("Length", lengthController, true),
            _cell("Diameter", diameterController, true),
          ]),
          _divider(),

          _row([
            _cell("Depth", depthController, true),
            _cellDrop("Tunnel Type", tunnelType, [
              "Road Tunnel",
              "Railway Tunnel",
              "Metro Tunnel",
              "Utility Tunnel",
            ], (v) => setState(() => tunnelType = v!)),
            _cellDrop("Rock Type", rockType, [
              "Soft Rock",
              "Hard Rock",
              "Soil",
            ], (v) => setState(() => rockType = v!)),
            _cell("Rock Strength", rockStrengthController, true),
          ]),
          _divider(),

          _row([
            _cell("Groundwater", groundwaterController, true),
            _cellDrop("Method", excavationMethod, [
              "TBM",
              "NATM",
              "Drill & Blast",
            ], (v) => setState(() => excavationMethod = v!)),
            _cell("Lining Thickness", liningThicknessController, true),
            _cellDrop("Concrete", concreteGrade, [
              "M25",
              "M30",
              "M35",
            ], (v) => setState(() => concreteGrade = v!)),
          ]),
          _divider(),

          _row([
            _cell("Rebar Diameter", rebarDiameterController, true),
            _cell("Ventilation Dia", ventilationDiameterController, true),
            _cell("Drainage Width", drainageWidthController, true),
            _cellDrop("Scale", scale, [
              "1:100",
              "1:200",
              "1:500",
            ], (v) => setState(() => scale = v!)),
          ]),
          _divider(),

          _row([
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
            const Expanded(child: SizedBox()),
          ]),
          _divider(),

          Padding(padding: const EdgeInsets.all(16), child: _submitButton()),
        ],
      ),
    );
  }

  // ================= MOBILE =================
  Widget _mobileLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _mField("Project Name", projectNameController, false),
          _mField("Location", locationController, false),
          _mField("Length", lengthController, true),
          _mField("Diameter", diameterController, true),
          _mField("Depth", depthController, true),
          _mDrop("Tunnel Type", tunnelType, [
            "Road Tunnel",
            "Railway Tunnel",
            "Metro Tunnel",
            "Utility Tunnel",
          ], (v) => setState(() => tunnelType = v!)),
          _mDrop("Rock Type", rockType, [
            "Soft Rock",
            "Hard Rock",
            "Soil",
          ], (v) => setState(() => rockType = v!)),
          _mField("Rock Strength", rockStrengthController, true),
          _mField("Groundwater", groundwaterController, true),
          _mDrop("Method", excavationMethod, [
            "TBM",
            "NATM",
            "Drill & Blast",
          ], (v) => setState(() => excavationMethod = v!)),
          _mField("Lining Thickness", liningThicknessController, true),
          _mDrop("Concrete", concreteGrade, [
            "M25",
            "M30",
            "M35",
          ], (v) => setState(() => concreteGrade = v!)),
          _mField("Rebar Diameter", rebarDiameterController, true),
          _mField("Ventilation Dia", ventilationDiameterController, true),
          _mField("Drainage Width", drainageWidthController, true),
          _mDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
          ], (v) => setState(() => scale = v!)),
          _mDrop("Sheet", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _mDrop("Detail", detailLevel, [
            "Concept",
            "Standard",
            "Construction",
          ], (v) => setState(() => detailLevel = v!)),

          const SizedBox(height: 20),
          _submitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= BUTTON (UNCHANGED LOGIC) =================
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        child: const Text("Generate Tunnel Drawing"),
        onPressed: () {
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
        },
      ),
    );
  }

  // ================= COMMON =================
  Widget _row(List<Widget> children) =>
      IntrinsicHeight(child: Row(children: children));

  Widget _cell(String label, TextEditingController c, bool isNumber) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
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

  Widget _mField(String label, TextEditingController c, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _mDrop(
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
