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

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS (UNCHANGED)
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  final slotWidthController = TextEditingController(text: "2.5");
  final slotLengthController = TextEditingController(text: "5.0");
  final slotCountController = TextEditingController();

  final laneWidthController = TextEditingController(text: "6");
  final entryWidthController = TextEditingController(text: "4");
  final exitWidthController = TextEditingController(text: "4");

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
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Parking Layout Design"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      /// 🔥 GRADIENT
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue, accentBlue2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1500),
            padding: const EdgeInsets.all(14),
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row([
            _cell("Project Name", projectNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cellDrop("Parking Type", parkingType, [
              "Surface Parking",
              "Basement Parking",
              "Multi-Level Parking",
            ], (v) => setState(() => parkingType = v!)),
            _cell("Length", lengthController),
          ]),
          _divider(),

          _row([
            _cell("Width", widthController),
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _cell("Slot Width", slotWidthController),
            _cell("Slot Length", slotLengthController),
          ]),
          _divider(),

          _row([
            _cell("Slots", slotCountController),
            _cellDrop("Angle", parkingAngle, [
              "90°",
              "60°",
              "45°",
            ], (v) => setState(() => parkingAngle = v!)),
            _cell("Lane Width", laneWidthController),
            _cell("Entry Width", entryWidthController),
          ]),
          _divider(),

          _row([
            _cell("Exit Width", exitWidthController),
            _cell("Floors", floorsController),
            _cell("Ramp Width", rampWidthController),
            _cell("Ramp Slope", rampSlopeController),
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

          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: _submitButton(),
            ),
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _mobileField("Project Name", projectNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileDrop("Parking Type", parkingType, [
            "Surface Parking",
            "Basement Parking",
            "Multi-Level Parking",
          ], (v) => setState(() => parkingType = v!)),
          _mobileField("Length", lengthController),
          _mobileField("Width", widthController),
          _mobileDrop("Orientation", orientation, [
            "North",
            "South",
            "East",
            "West",
          ], (v) => setState(() => orientation = v!)),
          _mobileField("Slot Width", slotWidthController),
          _mobileField("Slot Length", slotLengthController),
          _mobileField("Slots", slotCountController),
          _mobileDrop("Angle", parkingAngle, [
            "90°",
            "60°",
            "45°",
          ], (v) => setState(() => parkingAngle = v!)),
          _mobileField("Lane Width", laneWidthController),
          _mobileField("Entry Width", entryWidthController),
          _mobileField("Exit Width", exitWidthController),
          _mobileField("Floors", floorsController),
          _mobileField("Ramp Width", rampWidthController),
          _mobileField("Ramp Slope", rampSlopeController),
          _mobileDrop("Scale", scale, [
            "1:100",
            "1:200",
            "1:500",
          ], (v) => setState(() => scale = v!)),
          _mobileDrop("Sheet", sheetSize, [
            "A0",
            "A1",
            "A2",
            "A3",
          ], (v) => setState(() => sheetSize = v!)),
          _mobileDrop("Detail", detailLevel, [
            "Concept",
            "Standard",
            "Construction",
          ], (v) => setState(() => detailLevel = v!)),
          const SizedBox(height: 10),
          _submitButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ================= BUTTON (UNCHANGED) =================
  Widget _submitButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                setState(() => isLoading = true);

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

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "parking",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  if (response["success"] == true) {
                    Get.snackbar(
                      "Success",
                      response["message"] ?? "Drawing generated successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      response["message"] ?? "Something went wrong",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } catch (e) {
                  setState(() => isLoading = false);

                  Get.snackbar(
                    "Error",
                    e.toString(),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
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
            : const Text("Generate Parking Layout"),
      ),
    );
  }

  // ================= COMMON =================
  Widget _row(List<Widget> cells) =>
      IntrinsicHeight(child: Row(children: cells));

  Widget _cell(String label, TextEditingController c, {bool isNumber = true}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: c,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (v) => v!.isEmpty ? "Required" : null,
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

  Widget _mobileField(
    String label,
    TextEditingController c, {
    bool isNumber = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _mobileDrop(
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
