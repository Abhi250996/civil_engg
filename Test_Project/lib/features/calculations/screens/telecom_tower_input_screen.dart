import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class TelecomTowerInputScreen extends StatefulWidget {
  const TelecomTowerInputScreen({super.key});

  @override
  State<TelecomTowerInputScreen> createState() =>
      _TelecomTowerInputScreenState();
}

class _TelecomTowerInputScreenState extends State<TelecomTowerInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 BRAND COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6); // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC); // Soft White

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final heightController = TextEditingController();
  final baseWidthController = TextEditingController();
  final antennaLevelsController = TextEditingController();
  final antennasPerLevelController = TextEditingController();
  final antennaHeightController = TextEditingController();
  final windSpeedController = TextEditingController();
  final windPressureController = TextEditingController();
  final foundationDepthController = TextEditingController();

  String towerType = "Monopole Tower";
  String sectorCount = "3 Sector";
  String foundationType = "Pile Foundation";
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Telecom Tower Design"),
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
            stops: [0.0, 0.3, 0.8],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: Container(
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
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
        _sectionHeader("Project Identification"),
        _mField("Project Name", projectNameController, unit: ""),
        _mField("Site Location", locationController, unit: ""),
        _mDrop("Tower Type", towerType, [
          "Monopole Tower",
          "Lattice Tower",
          "Guyed Tower",
        ], (v) => setState(() => towerType = v!)),

        _divider(),
        _sectionHeader("Geometry (Metric)"),
        Row(
          children: [
            Expanded(
              child: _mField("Total Height", heightController, unit: "m"),
            ),
            Expanded(
              child: _mField("Base Width", baseWidthController, unit: "m"),
            ),
          ],
        ),

        _divider(),
        _sectionHeader("Antenna Configuration"),
        Row(
          children: [
            Expanded(
              child: _mField("Levels", antennaLevelsController, unit: "qty"),
            ),
            Expanded(
              child: _mField(
                "Antennas/Lvl",
                antennasPerLevelController,
                unit: "qty",
              ),
            ),
          ],
        ),
        _mField("Antenna Mounting Ht", antennaHeightController, unit: "m"),
        _mDrop("Sector Count", sectorCount, [
          "3 Sector",
          "4 Sector",
          "6 Sector",
        ], (v) => setState(() => sectorCount = v!)),

        _divider(),
        _sectionHeader("Environmental Loads"),
        Row(
          children: [
            Expanded(
              child: _mField("Wind Speed", windSpeedController, unit: "m/s"),
            ),
            Expanded(
              child: _mField(
                "Wind Pressure",
                windPressureController,
                unit: "kN/m²",
              ),
            ),
          ],
        ),

        _divider(),
        _sectionHeader("Substructure"),
        _mDrop("Foundation", foundationType, [
          "Pile Foundation",
          "Raft Foundation",
          "Pad Foundation",
        ], (v) => setState(() => foundationType = v!)),
        _mField("Foundation Depth", foundationDepthController, unit: "m"),

        _divider(),
        _sectionHeader("Drafting Standards"),
        Row(
          children: [
            Expanded(
              child: _mDrop("Scale", scale, [
                "1:50",
                "1:100",
                "1:200",
              ], (v) => setState(() => scale = v!)),
            ),
            Expanded(
              child: _mDrop("Sheet", sheetSize, [
                "A0",
                "A1",
                "A2",
                "A3",
              ], (v) => setState(() => sheetSize = v!)),
            ),
          ],
        ),
        _mDrop("Detail Level", detailLevel, [
          "Concept",
          "Standard",
          "Construction",
        ], (v) => setState(() => detailLevel = v!)),

        const SizedBox(height: 30),
        _submitButton(),
        const SizedBox(height: 10),
      ],
    );
  }

  // ─── HELPER WIDGETS ──────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _mField(String label, TextEditingController c, {String unit = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextFormField(
        controller: c,
        keyboardType: unit.isEmpty
            ? TextInputType.text
            : const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => v!.isEmpty ? "Required" : null,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    child: Divider(color: Colors.grey.shade200, thickness: 1.2),
  );

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isLoading ? null : _handleSubmission,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "GENERATE TOWER DRAWING",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Future<void> _handleSubmission() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final res = await controller.generateDrawingFromInputs(
        type: "telecom",
        inputData: {
          "project": {
            "name": projectNameController.text,
            "location": locationController.text,
          },
          "tower": {
            "type": towerType,
            "height": heightController.text,
            "baseWidth": baseWidthController.text,
            "antennaLevels": antennaLevelsController.text,
          },
          "antenna": {
            "antennasPerLevel": antennasPerLevelController.text,
            "antennaHeight": antennaHeightController.text,
            "sector": sectorCount,
          },
          "wind": {
            "speed": windSpeedController.text,
            "pressure": windPressureController.text,
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
        },
      );

      Get.snackbar(
        "Status",
        res["message"] ?? "Processing complete",
        backgroundColor: res["success"] == true ? Colors.green : Colors.red,
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
