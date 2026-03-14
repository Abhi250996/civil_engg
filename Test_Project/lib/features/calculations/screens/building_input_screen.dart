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

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// SITE
  final plotLengthController = TextEditingController();
  final plotWidthController = TextEditingController();
  String orientation = "North";

  /// BUILDING
  final floorsController = TextEditingController();
  final roomsController = TextEditingController();
  final floorHeightController = TextEditingController();

  /// SETBACKS
  final frontSetbackController = TextEditingController();
  final rearSetbackController = TextEditingController();
  final sideSetbackController = TextEditingController();

  /// STRUCTURAL
  final soilController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final designLoadController = TextEditingController();

  /// DRAWING SETTINGS
  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Building Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// PROJECT
              sectionTitle("Project Information"),

              field(projectNameController, "Project Name"),
              field(locationController, "Location"),

              const SizedBox(height: 25),

              /// SITE
              sectionTitle("Site Geometry"),

              field(plotLengthController, "Plot Length (m)"),
              field(plotWidthController, "Plot Width (m)"),

              dropdown("Orientation", orientation, [
                "North",
                "South",
                "East",
                "West",
              ], (v) => setState(() => orientation = v!)),

              const SizedBox(height: 25),

              /// BUILDING PROGRAM
              sectionTitle("Building Program"),

              field(floorsController, "Number of Floors"),
              field(roomsController, "Rooms / BHK"),
              field(floorHeightController, "Floor Height (m)"),

              const SizedBox(height: 25),

              /// SETBACKS
              sectionTitle("Building Setbacks"),

              field(frontSetbackController, "Front Setback (m)"),
              field(rearSetbackController, "Rear Setback (m)"),
              field(sideSetbackController, "Side Setback (m)"),

              const SizedBox(height: 25),

              /// STRUCTURAL
              sectionTitle("Structural Parameters"),

              field(soilController, "Soil Bearing Capacity (kN/m²)"),
              field(seismicZoneController, "Seismic Zone"),
              field(designLoadController, "Design Load (kN)"),

              const SizedBox(height: 25),

              /// DRAWING SETTINGS
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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  child: const Text("Generate Building Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "site": {
                        "length": plotLengthController.text,
                        "width": plotWidthController.text,
                        "orientation": orientation,
                      },

                      "building": {
                        "floors": floorsController.text,
                        "rooms": roomsController.text,
                        "floorHeight": floorHeightController.text,
                      },

                      "setbacks": {
                        "front": frontSetbackController.text,
                        "rear": rearSetbackController.text,
                        "side": sideSetbackController.text,
                      },

                      "structure": {
                        "soilBearingCapacity": soilController.text,
                        "seismicZone": seismicZoneController.text,
                        "designLoad": designLoadController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "building",
                      inputData: data,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? "Required" : null,
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
      child: DropdownButtonFormField(
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
