import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class ParkingInputScreen extends StatefulWidget {
  const ParkingInputScreen({super.key});

  @override
  State<ParkingInputScreen> createState() => _ParkingInputScreenState();
}

class _ParkingInputScreenState extends State<ParkingInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// SITE
  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  /// PARKING
  final slotWidthController = TextEditingController(text: "2.5");
  final slotLengthController = TextEditingController(text: "5.0");
  final slotCountController = TextEditingController();

  /// CIRCULATION
  final laneWidthController = TextEditingController(text: "6");
  final entryWidthController = TextEditingController(text: "4");
  final exitWidthController = TextEditingController(text: "4");

  /// MULTI LEVEL
  final floorsController = TextEditingController(text: "1");
  final rampWidthController = TextEditingController(text: "4");
  final rampSlopeController = TextEditingController(text: "12");

  String parkingType = "Surface Parking";
  String orientation = "North";
  String parkingAngle = "90°";

  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parking Layout Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              sectionTitle("Project Information"),

              field(projectNameController, "Project Name"),
              field(locationController, "Location"),

              const SizedBox(height: 20),

              /// PARKING TYPE
              sectionTitle("Parking Type"),

              dropdown("Parking Type", parkingType, [
                "Surface Parking",
                "Basement Parking",
                "Multi-Level Parking",
              ], (v) => setState(() => parkingType = v!)),

              const SizedBox(height: 20),

              /// SITE
              sectionTitle("Site Geometry"),

              field(lengthController, "Parking Length (m)"),
              field(widthController, "Parking Width (m)"),

              dropdown("Orientation", orientation, [
                "North",
                "South",
                "East",
                "West",
              ], (v) => setState(() => orientation = v!)),

              const SizedBox(height: 20),

              /// PARKING SLOTS
              sectionTitle("Parking Layout"),

              field(slotWidthController, "Parking Slot Width (m)"),
              field(slotLengthController, "Parking Slot Length (m)"),
              field(slotCountController, "Number of Parking Slots"),

              dropdown(
                "Parking Angle",
                parkingAngle,
                ["90°", "60°", "45°"],
                (v) => setState(() => parkingAngle = v!),
              ),

              const SizedBox(height: 20),

              /// CIRCULATION
              sectionTitle("Circulation"),

              field(laneWidthController, "Driving Lane Width (m)"),
              field(entryWidthController, "Entry Gate Width (m)"),
              field(exitWidthController, "Exit Gate Width (m)"),

              const SizedBox(height: 20),

              /// MULTI LEVEL
              sectionTitle("Multi-Level Parking"),

              field(floorsController, "Number of Floors"),
              field(rampWidthController, "Ramp Width (m)"),
              field(rampSlopeController, "Ramp Slope (%)"),

              const SizedBox(height: 20),

              /// DRAWING
              sectionTitle("Drawing Settings"),

              dropdown("Scale", scale, [
                "1:100",
                "1:200",
                "1:500",
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
                  child: const Text("Generate Parking Layout"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "site": {
                        "length": lengthController.text,
                        "width": widthController.text,
                        "orientation": orientation,
                      },

                      "parking": {
                        "type": parkingType,
                        "slotWidth": slotWidthController.text,
                        "slotLength": slotLengthController.text,
                        "slots": slotCountController.text,
                        "angle": parkingAngle,
                      },

                      "circulation": {
                        "laneWidth": laneWidthController.text,
                        "entryWidth": entryWidthController.text,
                        "exitWidth": exitWidthController.text,
                      },

                      "multilevel": {
                        "floors": floorsController.text,
                        "rampWidth": rampWidthController.text,
                        "rampSlope": rampSlopeController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "parking",
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
        validator: (v) => v!.isEmpty ? "Required" : null,
        keyboardType: TextInputType.number,
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
