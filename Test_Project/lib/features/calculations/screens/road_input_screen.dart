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

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS (UNCHANGED)
  final roadNameController = TextEditingController();
  final locationController = TextEditingController();

  final roadLengthController = TextEditingController();
  final carriageWidthController = TextEditingController();
  final lanesController = TextEditingController();
  final shoulderWidthController = TextEditingController();

  final speedController = TextEditingController();
  final trafficController = TextEditingController();

  final thicknessController = TextEditingController();
  final cbrController = TextEditingController();

  final drainWidthController = TextEditingController();
  final drainDepthController = TextEditingController();

  String roadType = "Highway";
  String surfaceType = "Asphalt";
  String drainType = "Open Drain";

  String scale = "1:200";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];

    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Road Design"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

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
                  ? _desktopLayout(project)
                  : SingleChildScrollView(child: _mobileLayout(project)),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout(dynamic project) {
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
            _cell("Road Name", roadNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cell("Length", roadLengthController),
            _cell("Carriage Width", carriageWidthController),
          ]),
          _divider(),

          _row([
            _cell("Lanes", lanesController),
            _cell("Shoulder Width", shoulderWidthController),
            _cellDrop("Road Type", roadType, [
              "Highway",
              "City Road",
              "Rural Road",
            ], (v) => setState(() => roadType = v!)),
            _cell("Speed", speedController),
          ]),
          _divider(),

          _row([
            _cell("Traffic Volume", trafficController),
            _cellDrop("Surface", surfaceType, [
              "Asphalt",
              "Concrete",
            ], (v) => setState(() => surfaceType = v!)),
            _cell("Thickness", thicknessController),
            _cell("CBR", cbrController),
          ]),
          _divider(),

          _row([
            _cellDrop("Drain Type", drainType, [
              "Open Drain",
              "Covered Drain",
            ], (v) => setState(() => drainType = v!)),
            _cell("Drain Width", drainWidthController),
            _cell("Drain Depth", drainDepthController),
            _cellDrop("Scale", scale, [
              "1:100",
              "1:200",
              "1:500",
            ], (v) => setState(() => scale = v!)),
          ]),
          _divider(),

          _row([
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
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _mobileField("Road Name", roadNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Length", roadLengthController),
          _mobileField("Carriage Width", carriageWidthController),
          _mobileField("Lanes", lanesController),
          _mobileField("Shoulder Width", shoulderWidthController),
          _mobileDrop("Road Type", roadType, [
            "Highway",
            "City Road",
            "Rural Road",
          ], (v) => setState(() => roadType = v!)),
          _mobileField("Speed", speedController),
          _mobileField("Traffic Volume", trafficController),
          _mobileDrop("Surface", surfaceType, [
            "Asphalt",
            "Concrete",
          ], (v) => setState(() => surfaceType = v!)),
          _mobileField("Thickness", thicknessController),
          _mobileField("CBR", cbrController),
          _mobileDrop("Drain Type", drainType, [
            "Open Drain",
            "Covered Drain",
          ], (v) => setState(() => drainType = v!)),
          _mobileField("Drain Width", drainWidthController),
          _mobileField("Drain Depth", drainDepthController),
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

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "road",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  Get.snackbar(
                    response["success"] == true ? "Success" : "Error",
                    response["message"] ?? "Something went wrong",
                    backgroundColor: response["success"] == true
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
            : const Text("Generate Road Drawing"),
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
