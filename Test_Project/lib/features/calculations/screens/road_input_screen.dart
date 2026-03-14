import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class RoadInputScreen extends StatefulWidget {
  const RoadInputScreen({super.key});

  @override
  State<RoadInputScreen> createState() => _RoadInputScreenState();
}

class _RoadInputScreenState extends State<RoadInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// PROJECT
  final roadNameController = TextEditingController();
  final locationController = TextEditingController();

  /// GEOMETRY
  final roadLengthController = TextEditingController();
  final carriageWidthController = TextEditingController();
  final lanesController = TextEditingController();
  final shoulderWidthController = TextEditingController();

  /// TRAFFIC
  final speedController = TextEditingController();
  final trafficController = TextEditingController();

  String roadType = "Highway";

  /// PAVEMENT
  String surfaceType = "Asphalt";
  final thicknessController = TextEditingController();
  final cbrController = TextEditingController();

  /// DRAINAGE
  String drainType = "Open Drain";
  final drainWidthController = TextEditingController();
  final drainDepthController = TextEditingController();

  /// DRAWING
  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    return Scaffold(
      appBar: AppBar(title: const Text("Road Design")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// PROJECT
              sectionTitle("Project"),

              Text("Project: ${project?.name ?? "Unnamed"}"),

              field(roadNameController, "Road Name"),
              field(locationController, "Location"),

              const SizedBox(height: 20),

              /// GEOMETRY
              sectionTitle("Road Geometry"),

              field(roadLengthController, "Road Length (km)"),
              field(carriageWidthController, "Carriageway Width (m)"),
              field(lanesController, "Number of Lanes"),
              field(shoulderWidthController, "Shoulder Width (m)"),

              const SizedBox(height: 20),

              /// TRAFFIC
              sectionTitle("Traffic Parameters"),

              dropdown("Road Type", roadType, [
                "Highway",
                "City Road",
                "Rural Road",
              ], (v) => setState(() => roadType = v!)),

              field(speedController, "Design Speed (km/h)"),
              field(trafficController, "Traffic Volume (vehicles/day)"),

              const SizedBox(height: 20),

              /// PAVEMENT
              sectionTitle("Pavement Design"),

              dropdown("Surface Type", surfaceType, [
                "Asphalt",
                "Concrete",
              ], (v) => setState(() => surfaceType = v!)),

              field(thicknessController, "Pavement Thickness (mm)"),
              field(cbrController, "Subgrade CBR (%)"),

              const SizedBox(height: 20),

              /// DRAINAGE
              sectionTitle("Drainage"),

              dropdown("Drain Type", drainType, [
                "Open Drain",
                "Covered Drain",
              ], (v) => setState(() => drainType = v!)),

              field(drainWidthController, "Drain Width (m)"),
              field(drainDepthController, "Drain Depth (m)"),

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
                  child: const Text("Generate Road Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": roadNameController.text,
                        "location": locationController.text,
                      },

                      "geometry": {
                        "length": roadLengthController.text,
                        "width": carriageWidthController.text,
                        "lanes": lanesController.text,
                        "shoulderWidth": shoulderWidthController.text,
                      },

                      "traffic": {
                        "roadType": roadType,
                        "speed": speedController.text,
                        "volume": trafficController.text,
                      },

                      "pavement": {
                        "surfaceType": surfaceType,
                        "thickness": thicknessController.text,
                        "cbr": cbrController.text,
                      },

                      "drainage": {
                        "type": drainType,
                        "width": drainWidthController.text,
                        "depth": drainDepthController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "road",
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
