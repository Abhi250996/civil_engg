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

  /// ================= LOADER =================
  bool isLoading = false;

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// TOWER
  final heightController = TextEditingController();
  final baseWidthController = TextEditingController();
  final antennaLevelsController = TextEditingController();

  /// ANTENNA
  final antennasPerLevelController = TextEditingController();
  final antennaHeightController = TextEditingController();

  /// WIND
  final windSpeedController = TextEditingController();
  final windPressureController = TextEditingController();

  /// FOUNDATION
  final foundationDepthController = TextEditingController();

  String towerType = "Monopole Tower";
  String sectorCount = "3 Sector";
  String foundationType = "Pile Foundation";

  /// DRAWING
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Construction";

  @override
  void dispose() {
    projectNameController.dispose();
    locationController.dispose();
    heightController.dispose();
    baseWidthController.dispose();
    antennaLevelsController.dispose();
    antennasPerLevelController.dispose();
    antennaHeightController.dispose();
    windSpeedController.dispose();
    windPressureController.dispose();
    foundationDepthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Telecom Tower Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project Information"),

              field(projectNameController, "Project Name", isNumber: false),
              field(locationController, "Location", isNumber: false),

              const SizedBox(height: 20),

              /// TOWER TYPE
              sectionTitle("Tower Type"),

              dropdown("Tower Type", towerType, [
                "Monopole Tower",
                "Lattice Tower",
                "Guyed Tower",
              ], (v) => setState(() => towerType = v!)),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Tower Geometry"),

              field(heightController, "Tower Height (m)"),
              field(baseWidthController, "Base Width (m)"),
              field(antennaLevelsController, "Number of Antenna Levels"),

              const SizedBox(height: 20),

              /// ANTENNA
              sectionTitle("Antenna Configuration"),

              field(antennasPerLevelController, "Antennas per Level"),
              field(antennaHeightController, "Antenna Height (m)"),

              dropdown("Sector Count", sectorCount, [
                "3 Sector",
                "4 Sector",
                "6 Sector",
              ], (v) => setState(() => sectorCount = v!)),

              const SizedBox(height: 20),

              /// WIND
              sectionTitle("Wind Load"),

              field(windSpeedController, "Wind Speed (km/h)"),
              field(windPressureController, "Wind Pressure (kN/m²)"),

              const SizedBox(height: 20),

              /// FOUNDATION
              sectionTitle("Foundation"),

              dropdown(
                "Foundation Type",
                foundationType,
                ["Pile Foundation", "Raft Foundation", "Pad Foundation"],
                (v) => setState(() => foundationType = v!),
              ),

              field(foundationDepthController, "Foundation Depth (m)"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),

              dropdown("Scale", scale, [
                "1:50",
                "1:100",
                "1:200",
              ], (v) => setState(() => scale = v!)),

              dropdown("Sheet Size", sheetSize, [
                "A0",
                "A1",
                "A2",
                "A3",
              ], (v) => setState(() => sheetSize = v!)),

              dropdown("Detail Level", detailLevel, [
                "Concept",
                "Standard",
                "Construction",
              ], (v) => setState(() => detailLevel = v!)),

              const SizedBox(height: 40),

              /// ================= BUTTON =================
              SizedBox(
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
                              "antennasPerLevel":
                                  antennasPerLevelController.text,
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
                            final res = await controller
                                .generateDrawingFromInputs(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= COMMON =================

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget field(TextEditingController c, String label, {bool isNumber = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget dropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
