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

  bool isLoading = false;

  /// 🎨 UI COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();
  final plotLengthController = TextEditingController();
  final plotWidthController = TextEditingController();
  String orientation = "North";
  final floorsController = TextEditingController();
  final roomsController = TextEditingController();
  final floorHeightController = TextEditingController();
  final frontSetbackController = TextEditingController();
  final rearSetbackController = TextEditingController();
  final sideSetbackController = TextEditingController();
  final soilController = TextEditingController();
  final seismicZoneController = TextEditingController();
  final designLoadController = TextEditingController();

  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Building Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      /// 🔥 GRADIENT BACKGROUND
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
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(16),

            child: Form(
              key: formKey,
              child: isDesktop ? _desktopLayout() : _mobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= DESKTOP =================
  Widget _desktopLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
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
            _cell("Project Name", projectNameController, false),
            _cell("Location", locationController, false),
            _cell("Length (m)", plotLengthController),
            _cell("Width (m)", plotWidthController),
          ]),
          _divider(),

          _row([
            _cellDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _cell("Floors", floorsController),
            _cell("Rooms", roomsController),
            _cell("Floor Height", floorHeightController),
          ]),
          _divider(),

          _row([
            _cell("Front", frontSetbackController),
            _cell("Rear", rearSetbackController),
            _cell("Side", sideSetbackController),
            _cell("Soil SBC", soilController),
          ]),
          _divider(),

          _row([
            _cell("Seismic Zone", seismicZoneController),
            _cell("Design Load", designLoadController),
            _cellDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
            ], (v) => setState(() => scale = v!)),
            _cellDrop("Sheet Size", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
          ]),
          _divider(),

          _row([
            _cellDrop("Detail Level", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const Expanded(child: SizedBox()),
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

  /// ================= MOBILE =================
  Widget _mobileLayout() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _mobileField("Project Name", projectNameController, false),
            _mobileField("Location", locationController, false),
            _mobileField("Length (m)", plotLengthController),
            _mobileField("Width (m)", plotWidthController),
            _mobileDrop("Orientation", orientation, [
              "North",
              "South",
              "East",
              "West",
            ], (v) => setState(() => orientation = v!)),
            _mobileField("Floors", floorsController),
            _mobileField("Rooms", roomsController),
            _mobileField("Floor Height", floorHeightController),
            _mobileField("Front", frontSetbackController),
            _mobileField("Rear", rearSetbackController),
            _mobileField("Side", sideSetbackController),
            _mobileField("Soil SBC", soilController),
            _mobileField("Seismic Zone", seismicZoneController),
            _mobileField("Design Load", designLoadController),
            _mobileDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
            ], (v) => setState(() => scale = v!)),
            _mobileDrop("Sheet Size", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
            _mobileDrop("Detail Level", detailLevel, [
              "Concept",
              "Standard",
              "Construction",
            ], (v) => setState(() => detailLevel = v!)),
            const SizedBox(height: 10),
            _submitButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// ================= COMMON =================
  Widget _row(List<Widget> children) =>
      IntrinsicHeight(child: Row(children: children));

  Widget _cell(String label, TextEditingController c, [bool isNumber = true]) {
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
    TextEditingController c, [
    bool isNumber = true,
  ]) {
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

  /// ================= BUTTON =================
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

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "building",
                    inputData: data,
                  );

                  setState(() => isLoading = false);

                  if (response["success"] == true) {
                    Get.snackbar(
                      "Success",
                      response["message"] ?? "Drawing generated",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      response["message"] ?? "Something went wrong",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
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
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Building Drawing"),
      ),
    );
  }
}
