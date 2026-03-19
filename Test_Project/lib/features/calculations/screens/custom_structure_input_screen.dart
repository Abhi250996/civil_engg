import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class CustomStructureInputScreen extends StatefulWidget {
  const CustomStructureInputScreen({super.key});

  @override
  State<CustomStructureInputScreen> createState() =>
      _CustomStructureInputScreenState();
}

class _CustomStructureInputScreenState
    extends State<CustomStructureInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 SAME COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final structureNameController = TextEditingController();
  final descriptionController = TextEditingController();

  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final levelsController = TextEditingController();

  final designLoadController = TextEditingController();
  final liveLoadController = TextEditingController();
  final windLoadController = TextEditingController();
  final seismicZoneController = TextEditingController();

  final foundationDepthController = TextEditingController();
  final soilController = TextEditingController();

  String materialType = "Concrete";
  String foundationType = "Isolated Footing";

  String scale = "1:100";
  String sheetSize = "A1";
  String detailLevel = "Standard";

  /// RESPONSIVE (NOT REMOVED)
  int getCrossAxisCount(double width) {
    if (width > 1200) return 5;
    if (width > 800) return 3;
    return 2;
  }

  Widget responsiveGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: getCrossAxisCount(constraints.maxWidth),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final project = args['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Custom Structure Design"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      /// GRADIENT
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

  // ─── DESKTOP ─────────────────────────────
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
          /// PROJECT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Project: ${project?.name ?? "Unnamed"}"),
            ),
          ),
          _divider(),

          _row([
            _cell("Name", structureNameController, isNumber: false),
            _cell("Description", descriptionController, isNumber: false),
            _cell("Length", lengthController),
            _cell("Width", widthController),
          ]),
          _divider(),

          _row([
            _cell("Height", heightController),
            _cell("Levels", levelsController),
            _cellDrop("Material", materialType, [
              "Concrete",
              "Steel",
              "Composite",
            ], (v) => setState(() => materialType = v!)),
            _cell("Design Load", designLoadController),
          ]),
          _divider(),

          _row([
            _cell("Live Load", liveLoadController),
            _cell("Wind Load", windLoadController),
            _cell("Seismic", seismicZoneController),
            _cellDrop("Foundation", foundationType, [
              "Isolated Footing",
              "Raft",
              "Pile",
              "Strip Footing",
            ], (v) => setState(() => foundationType = v!)),
          ]),
          _divider(),

          _row([
            _cell("Depth", foundationDepthController),
            _cell("Soil", soilController),
            _cellDrop("Scale", scale, [
              "1:50",
              "1:100",
              "1:200",
            ], (v) => setState(() => scale = v!)),
            _cellDrop("Sheet", sheetSize, [
              "A0",
              "A1",
              "A2",
              "A3",
            ], (v) => setState(() => sheetSize = v!)),
          ]),
          _divider(),

          _row([
            _cellDrop("Detail", detailLevel, [
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

  // ─── MOBILE ─────────────────────────────
  Widget _mobileLayout(dynamic project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Project: ${project?.name ?? "Unnamed"}"),
          ),
          _mobileField("Name", structureNameController, isNumber: false),
          _mobileField("Description", descriptionController, isNumber: false),
          _mobileField("Length", lengthController),
          _mobileField("Width", widthController),
          _mobileField("Height", heightController),
          _mobileField("Levels", levelsController),
          _mobileDrop("Material", materialType, [
            "Concrete",
            "Steel",
            "Composite",
          ], (v) => setState(() => materialType = v!)),
          _mobileField("Design Load", designLoadController),
          _mobileField("Live Load", liveLoadController),
          _mobileField("Wind Load", windLoadController),
          _mobileField("Seismic", seismicZoneController),
          _mobileDrop("Foundation", foundationType, [
            "Isolated Footing",
            "Raft",
            "Pile",
            "Strip Footing",
          ], (v) => setState(() => foundationType = v!)),
          _mobileField("Depth", foundationDepthController),
          _mobileField("Soil", soilController),
          _mobileDrop("Scale", scale, [
            "1:50",
            "1:100",
            "1:200",
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

  /// COMMON
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
                  "structure": {
                    "name": structureNameController.text,
                    "description": descriptionController.text,
                    "material": materialType,
                  },
                  "geometry": {
                    "length": lengthController.text,
                    "width": widthController.text,
                    "height": heightController.text,
                    "levels": levelsController.text,
                  },
                  "loads": {
                    "designLoad": designLoadController.text,
                    "liveLoad": liveLoadController.text,
                    "windLoad": windLoadController.text,
                    "seismicZone": seismicZoneController.text,
                  },
                  "foundation": {
                    "type": foundationType,
                    "depth": foundationDepthController.text,
                    "soilBearingCapacity": soilController.text,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "custom",
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
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Generate Custom Structure Drawing"),
      ),
    );
  }
}
