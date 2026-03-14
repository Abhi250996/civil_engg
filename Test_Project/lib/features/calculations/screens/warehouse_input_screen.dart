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

  /// PROJECT
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  /// DIMENSIONS
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  /// STRUCTURE
  final columnSpacingController = TextEditingController();
  final baysController = TextEditingController();

  /// STORAGE
  final rackHeightController = TextEditingController();
  final rackRowsController = TextEditingController();
  final aisleWidthController = TextEditingController();

  /// DOCK
  final docksController = TextEditingController();
  final dockWidthController = TextEditingController();
  final truckRadiusController = TextEditingController();

  /// FLOOR
  final floorLoadController = TextEditingController();
  final forkliftLoadController = TextEditingController();

  String roofType = "Steel Truss";

  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse Design")),

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

              /// DIMENSIONS
              sectionTitle("Warehouse Dimensions"),

              field(lengthController, "Warehouse Length (m)"),
              field(widthController, "Warehouse Width (m)"),
              field(heightController, "Building Height (m)"),

              const SizedBox(height: 20),

              /// STRUCTURE
              sectionTitle("Structural Layout"),

              field(columnSpacingController, "Column Spacing (m)"),
              field(baysController, "Number of Bays"),

              dropdown("Roof Type", roofType, [
                "Steel Truss",
                "Portal Frame",
              ], (v) => setState(() => roofType = v!)),

              const SizedBox(height: 20),

              /// STORAGE
              sectionTitle("Storage System"),

              field(rackHeightController, "Rack Height (m)"),
              field(rackRowsController, "Rack Rows"),
              field(aisleWidthController, "Aisle Width (m)"),

              const SizedBox(height: 20),

              /// DOCK
              sectionTitle("Loading Dock"),

              field(docksController, "Number of Loading Docks"),
              field(dockWidthController, "Dock Width (m)"),
              field(truckRadiusController, "Truck Turning Radius (m)"),

              const SizedBox(height: 20),

              /// FLOOR
              sectionTitle("Floor Load"),

              field(floorLoadController, "Floor Load Capacity (kN/m²)"),
              field(forkliftLoadController, "Forklift Load (tons)"),

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
                  child: const Text("Generate Warehouse Drawing"),

                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Map<String, dynamic> data = {
                      "project": {
                        "name": projectNameController.text,
                        "location": locationController.text,
                      },

                      "dimensions": {
                        "length": lengthController.text,
                        "width": widthController.text,
                        "height": heightController.text,
                      },

                      "structure": {
                        "columnSpacing": columnSpacingController.text,
                        "bays": baysController.text,
                        "roofType": roofType,
                      },

                      "storage": {
                        "rackHeight": rackHeightController.text,
                        "rackRows": rackRowsController.text,
                        "aisleWidth": aisleWidthController.text,
                      },

                      "dock": {
                        "docks": docksController.text,
                        "dockWidth": dockWidthController.text,
                        "truckRadius": truckRadiusController.text,
                      },

                      "floor": {
                        "loadCapacity": floorLoadController.text,
                        "forkliftLoad": forkliftLoadController.text,
                      },

                      "drawing": {
                        "scale": scale,
                        "sheetSize": sheetSize,
                        "detailLevel": detailLevel,
                      },
                    };

                    controller.generateDrawingFromInputs(
                      type: "warehouse",
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
