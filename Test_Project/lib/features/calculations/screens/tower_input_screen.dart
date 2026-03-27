import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TowerInputScreen extends StatefulWidget {
  const TowerInputScreen({super.key});

  @override
  State<TowerInputScreen> createState() => _TowerInputScreenState();
}

class _TowerInputScreenState extends State<TowerInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final heightController = TextEditingController();
  final baseWidthController = TextEditingController();
  final topWidthController = TextEditingController();
  final levelsController = TextEditingController();
  final legDiameterController = TextEditingController();
  final windSpeedController = TextEditingController();
  final windLoadController = TextEditingController();
  final foundationDepthController = TextEditingController();

  String towerType = "Transmission Tower";
  String bracingType = "X Bracing";
  String foundationType = "Pile Foundation";
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Tower Structure Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue, bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ), // Mobile Optimized Width
            padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 8,
                  ),
                  child: _mobileLayout(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Project Identification"),
        _mField("Project Name", projectNameController, false),
        _mField("Location", locationController, false),
        _mDrop("Tower Category", towerType, [
          "Transmission Tower",
          "Telecom Tower",
          "Observation Tower",
          "Power Line Tower",
        ], (v) => setState(() => towerType = v!)),

        _divider(),
        _sectionTitle("Geometric Specifications"),
        _mField("Total Height (m)", heightController, true),
        Row(
          children: [
            Expanded(
              child: _mField("Base Width (m)", baseWidthController, true),
            ),
            Expanded(child: _mField("Top Width (m)", topWidthController, true)),
          ],
        ),

        _divider(),
        _sectionTitle("Structural details"),
        _mField("Number of Levels", levelsController, true),
        _mField("Leg Diameter (mm)", legDiameterController, true),
        _mDrop("Bracing System", bracingType, [
          "X Bracing",
          "K Bracing",
        ], (v) => setState(() => bracingType = v!)),

        _divider(),
        _sectionTitle("Environmental Loads"),
        _mField("Wind Speed (km/h)", windSpeedController, true),
        _mField("Wind Load (kN/m²)", windLoadController, true),

        _divider(),
        _sectionTitle("Foundation & Drawing"),
        _mDrop(
          "Foundation Type",
          foundationType,
          ["Pile Foundation", "Raft Foundation", "Isolated Footing"],
          (v) => setState(() => foundationType = v!),
        ),
        _mField("Foundation Depth (m)", foundationDepthController, true),
        _mDrop("Blueprint Scale", scale, [
          "1:50",
          "1:100",
          "1:200",
        ], (v) => setState(() => scale = v!)),
        _mDrop("Sheet Size", sheetSize, [
          "A0",
          "A1",
          "A2",
          "A3",
        ], (v) => setState(() => sheetSize = v!)),
        _mDrop("Detail Level", detailLevel, [
          "Concept",
          "Standard",
          "Construction",
        ], (v) => setState(() => detailLevel = v!)),

        const SizedBox(height: 24),
        _submitButton(),
        const SizedBox(height: 12),
      ],
    );
  }

  // ─── UI COMPONENTS ──────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  Widget _mField(String label, TextEditingController c, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 14)),
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
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
    child: Divider(color: Colors.grey.shade300, thickness: 1),
  );

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
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
                  "GENERATE TOWER DRAWING",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
        ),
      ),
    );
  }

  Future<void> _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      "project": {
        "name": projectNameController.text,
        "location": locationController.text,
      },
      "tower": {
        "type": towerType,
        "height": heightController.text,
        "baseWidth": baseWidthController.text,
        "topWidth": topWidthController.text,
      },
      "structure": {
        "levels": levelsController.text,
        "legDiameter": legDiameterController.text,
        "bracing": bracingType,
      },
      "wind": {
        "speed": windSpeedController.text,
        "load": windLoadController.text,
      },
      "foundation": {
        "type": foundationType,
        "depth": foundationDepthController.text,
      },
      "drawing": {
        "scale": scale,
        "sheetSize": sheetSize,
        "detailLevel": detailLevel,
      },
    };

    try {
      await controller.generateDrawingFromInputs(
        type: "tower",
        inputData: data,
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
