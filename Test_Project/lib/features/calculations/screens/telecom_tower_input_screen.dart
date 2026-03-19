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

  /// 🎨 YOUR COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS (UNCHANGED)
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
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Telecom Tower Design"),
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
            _cellDrop("Tower Type", towerType, [
              "Monopole Tower",
              "Lattice Tower",
              "Guyed Tower",
            ], (v) => setState(() => towerType = v!)),
            _cell("Height", heightController, true),
          ]),
          _divider(),

          _row([
            _cell("Base Width", baseWidthController, true),
            _cell("Antenna Levels", antennaLevelsController, true),
            _cell("Antennas/Level", antennasPerLevelController, true),
            _cell("Antenna Height", antennaHeightController, true),
          ]),
          _divider(),

          _row([
            _cellDrop("Sector", sectorCount, [
              "3 Sector",
              "4 Sector",
              "6 Sector",
            ], (v) => setState(() => sectorCount = v!)),
            _cell("Wind Speed", windSpeedController, true),
            _cell("Wind Pressure", windPressureController, true),
            _cellDrop("Foundation", foundationType, [
              "Pile Foundation",
              "Raft Foundation",
              "Pad Foundation",
            ], (v) => setState(() => foundationType = v!)),
          ]),
          _divider(),

          _row([
            _cell("Foundation Depth", foundationDepthController, true),
            _cellDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
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
          ]),
          _divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: _submitButton(), // SAME BUTTON
          ),
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
          _mDrop("Tower Type", towerType, [
            "Monopole Tower",
            "Lattice Tower",
            "Guyed Tower",
          ], (v) => setState(() => towerType = v!)),
          _mField("Height", heightController, true),
          _mField("Base Width", baseWidthController, true),
          _mField("Antenna Levels", antennaLevelsController, true),
          _mField("Antennas/Level", antennasPerLevelController, true),
          _mField("Antenna Height", antennaHeightController, true),
          _mDrop("Sector", sectorCount, [
            "3 Sector",
            "4 Sector",
            "6 Sector",
          ], (v) => setState(() => sectorCount = v!)),
          _mField("Wind Speed", windSpeedController, true),
          _mField("Wind Pressure", windPressureController, true),
          _mDrop("Foundation", foundationType, [
            "Pile Foundation",
            "Raft Foundation",
            "Pad Foundation",
          ], (v) => setState(() => foundationType = v!)),
          _mField("Foundation Depth", foundationDepthController, true),
          _mDrop("Scale", scale, [
            "1:50",
            "1:100",
            "1:200",
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

  // ================= BUTTON (UNCHANGED) =================
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
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
                };

                try {
                  final res = await controller.generateDrawingFromInputs(
                    type: "telecom",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  Get.snackbar(
                    res["success"] == true ? "Success" : "Error",
                    res["message"] ?? "Something went wrong",
                    backgroundColor: res["success"] == true
                        ? Colors.green
                        : Colors.red,
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
            : const Text("Generate Telecom Tower Drawing"),
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
