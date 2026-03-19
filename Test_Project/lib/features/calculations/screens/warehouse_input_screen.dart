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

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  /// CONTROLLERS (UNCHANGED)
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  final columnSpacingController = TextEditingController();
  final baysController = TextEditingController();

  final rackHeightController = TextEditingController();
  final rackRowsController = TextEditingController();
  final aisleWidthController = TextEditingController();

  final docksController = TextEditingController();
  final dockWidthController = TextEditingController();
  final truckRadiusController = TextEditingController();

  final floorLoadController = TextEditingController();
  final forkliftLoadController = TextEditingController();

  String roofType = "Steel Truss";

  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Warehouse Design"),
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
            _cell("Width", widthController, true),
          ]),
          _divider(),

          _row([
            _cell("Height", heightController, true),
            _cell("Column Spacing", columnSpacingController, true),
            _cell("Bays", baysController, true),
            _cellDrop("Roof Type", roofType, [
              "Steel Truss",
              "Portal Frame",
            ], (v) => setState(() => roofType = v!)),
          ]),
          _divider(),

          _row([
            _cell("Rack Height", rackHeightController, true),
            _cell("Rack Rows", rackRowsController, true),
            _cell("Aisle Width", aisleWidthController, true),
            _cell("Docks", docksController, true),
          ]),
          _divider(),

          _row([
            _cell("Dock Width", dockWidthController, true),
            _cell("Truck Radius", truckRadiusController, true),
            _cell("Floor Load", floorLoadController, true),
            _cell("Forklift Load", forkliftLoadController, true),
          ]),
          _divider(),

          _row([
            _cellDrop("Scale", scale, [
              "1:100",
              "1:200",
              "1:500",
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
          _mField("Width", widthController, true),
          _mField("Height", heightController, true),
          _mField("Column Spacing", columnSpacingController, true),
          _mField("Bays", baysController, true),
          _mDrop("Roof Type", roofType, [
            "Steel Truss",
            "Portal Frame",
          ], (v) => setState(() => roofType = v!)),
          _mField("Rack Height", rackHeightController, true),
          _mField("Rack Rows", rackRowsController, true),
          _mField("Aisle Width", aisleWidthController, true),
          _mField("Docks", docksController, true),
          _mField("Dock Width", dockWidthController, true),
          _mField("Truck Radius", truckRadiusController, true),
          _mField("Floor Load", floorLoadController, true),
          _mField("Forklift Load", forkliftLoadController, true),
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

  // ================= BUTTON (UNCHANGED) =================
  Widget _submitButton() {
    return SizedBox(
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
