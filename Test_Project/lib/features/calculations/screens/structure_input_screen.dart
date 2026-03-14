import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class StructureInputScreen extends StatefulWidget {
  const StructureInputScreen({super.key});

  @override
  State<StructureInputScreen> createState() => _StructureInputScreenState();
}

class _StructureInputScreenState extends State<StructureInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const primaryBlue = Color(0xFF1E3A8A);
  static const bgColor = Color(0xFFF8FAFC);

  late String structureType;

  final Map<String, TextEditingController> inputs = {};

  /// ===============================
  /// STRUCTURE FIELD DEFINITIONS
  /// ===============================

  final Map<String, List<Map<String, String>>> structureFields = {
    /// BUILDING
    "building": [
      {"key": "plotLength", "label": "Plot Length", "unit": "m"},
      {"key": "plotWidth", "label": "Plot Width", "unit": "m"},
      {"key": "floors", "label": "Number of Floors", "unit": ""},
      {"key": "rooms", "label": "Rooms / BHK", "unit": ""},
      {"key": "floorHeight", "label": "Floor Height", "unit": "m"},
      {"key": "soil", "label": "Soil Bearing Capacity", "unit": "kN/m²"},
    ],

    /// ROAD
    "road": [
      {"key": "roadLength", "label": "Road Length", "unit": "km"},
      {"key": "carriagewayWidth", "label": "Carriageway Width", "unit": "m"},
      {"key": "pavementThickness", "label": "Pavement Thickness", "unit": "mm"},
      {"key": "lanes", "label": "Number of Lanes", "unit": ""},
    ],

    /// BRIDGE
    "bridge": [
      {"key": "spanLength", "label": "Span Length", "unit": "m"},
      {"key": "deckWidth", "label": "Deck Width", "unit": "m"},
      {"key": "pierSpacing", "label": "Pier Spacing", "unit": "m"},
      {"key": "designLoad", "label": "Design Load", "unit": "kN"},
    ],

    /// WATER TANK
    "tank": [
      {"key": "diameter", "label": "Tank Diameter", "unit": "m"},
      {"key": "height", "label": "Tank Height", "unit": "m"},
      {"key": "capacity", "label": "Capacity", "unit": "m³"},
    ],

    /// PIPELINE
    "pipeline": [
      {"key": "diameter", "label": "Pipe Diameter", "unit": "mm"},
      {"key": "length", "label": "Pipeline Length", "unit": "km"},
      {"key": "pressure", "label": "Pressure", "unit": "bar"},
    ],

    /// TELECOM TOWER
    "telecom": [
      {"key": "height", "label": "Tower Height", "unit": "m"},
      {"key": "baseWidth", "label": "Base Width", "unit": "m"},
      {"key": "windLoad", "label": "Wind Load", "unit": "kN/m²"},
    ],

    /// WAREHOUSE
    "warehouse": [
      {"key": "length", "label": "Warehouse Length", "unit": "m"},
      {"key": "width", "label": "Warehouse Width", "unit": "m"},
      {"key": "bays", "label": "Number of Bays", "unit": ""},
    ],

    /// RETAINING WALL
    "retaining_wall": [
      {"key": "wallHeight", "label": "Wall Height", "unit": "m"},
      {"key": "baseWidth", "label": "Base Width", "unit": "m"},
      {"key": "soilPressure", "label": "Soil Pressure", "unit": "kN/m²"},
    ],

    /// CHIMNEY
    "chimney": [
      {"key": "height", "label": "Chimney Height", "unit": "m"},
      {"key": "diameter", "label": "Chimney Diameter", "unit": "m"},
      {"key": "wallThickness", "label": "Wall Thickness", "unit": "mm"},
    ],
  };

  /// ===============================
  /// INIT
  /// ===============================

  @override
  void initState() {
    super.initState();

    structureType = (Get.arguments?["type"] ?? "building");

    final fields = structureFields[structureType] ?? [];

    for (final f in fields) {
      inputs[f["key"]!] = TextEditingController();
    }
  }

  /// ===============================
  /// UI
  /// ===============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          structureType.toUpperCase(),
          style: const TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Get.back(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _title("Project Information"),

              _text("Project Name", "projectName"),
              _text("Location", "location"),

              const SizedBox(height: 30),

              _title("Structure Parameters"),

              ..._dynamicFields(),

              const SizedBox(height: 40),

              Center(child: _generateButton()),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// DYNAMIC FIELD BUILDER
  /// ===============================

  List<Widget> _dynamicFields() {
    final fields = structureFields[structureType] ?? [];

    return fields.map((field) {
      final key = field["key"]!;
      final label = field["label"]!;
      final unit = field["unit"]!;

      inputs[key] ??= TextEditingController();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),

        child: TextFormField(
          controller: inputs[key],

          keyboardType: TextInputType.number,

          validator: (v) {
            if (v == null || v.isEmpty) return "Required";
            return null;
          },

          decoration: InputDecoration(
            labelText: unit.isEmpty ? label : "$label ($unit)",

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }).toList();
  }

  /// ===============================
  /// GENERATE BUTTON
  /// ===============================

  Widget _generateButton() {
    return SizedBox(
      width: 320,
      height: 55,

      child: Obx(
        () => ElevatedButton.icon(
          icon: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.architecture),

          label: Text(
            controller.isLoading.value ? "GENERATING..." : "GENERATE DRAWING",
          ),

          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (!_formKey.currentState!.validate()) return;

                  Map<String, dynamic> data = {};

                  inputs.forEach((k, v) {
                    data[k] = v.text;
                  });

                  controller.generateDrawingFromInputs(
                    type: structureType,
                    inputData: data,
                  );
                },

          style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
        ),
      ),
    );
  }

  /// ===============================
  /// HELPERS
  /// ===============================

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
      ),
    );
  }

  Widget _text(String label, String key) {
    inputs[key] ??= TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: inputs[key],

        validator: (v) {
          if (v == null || v.isEmpty) return "Required";
          return null;
        },

        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
