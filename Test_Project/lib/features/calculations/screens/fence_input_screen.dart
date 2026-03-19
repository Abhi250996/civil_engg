import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class FenceInputScreen extends StatefulWidget {
  const FenceInputScreen({super.key});

  @override
  State<FenceInputScreen> createState() => _FenceInputScreenState();
}

class _FenceInputScreenState extends State<FenceInputScreen> {
  final CalculationController controller = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// 🎨 COLORS
  static const Color primaryBlue = Color(0xFF7b7eba);
  static const Color accentBlue = Color(0xFFbdbcdc);
  static const Color accentBlue2 = Color(0xFFdeddee);

  /// CONTROLLERS
  final projectNameController = TextEditingController();
  final locationController = TextEditingController();

  final boundaryLengthController = TextEditingController();
  final fenceHeightController = TextEditingController();

  String fenceType = "Chain Link";
  final postSpacingController = TextEditingController();

  final postDiameterController = TextEditingController();
  final postDepthController = TextEditingController();
  final concreteGradeController = TextEditingController();

  final gateCountController = TextEditingController();
  final gateWidthController = TextEditingController();
  String gateType = "Sliding";

  String scale = "1:100";
  String sheetSize = "A2";
  String detailLevel = "Standard";

  /// RESPONSIVE (KEPT)
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
    final project = Get.arguments?['project'];
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Fence / Boundary Design"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
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

  // ─── DESKTOP ─────────────────────────
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Project: ${project?.name ?? "Unnamed"}"),
            ),
          ),
          _divider(),

          _row([
            _cell("Project Name", projectNameController, isNumber: false),
            _cell("Location", locationController, isNumber: false),
            _cell("Boundary Length", boundaryLengthController),
            _cell("Fence Height", fenceHeightController),
          ]),
          _divider(),

          _row([
            _cellDrop("Fence Type", fenceType, [
              "Chain Link",
              "Barbed Wire",
              "Steel Panel",
              "Concrete Wall",
            ], (v) => setState(() => fenceType = v!)),
            _cell("Post Spacing", postSpacingController),
            _cell("Post Diameter", postDiameterController),
            _cell("Post Depth", postDepthController),
          ]),
          _divider(),

          _row([
            _cell("Concrete Grade", concreteGradeController, isNumber: false),
            _cell("Gate Count", gateCountController),
            _cell("Gate Width", gateWidthController),
            _cellDrop("Gate Type", gateType, [
              "Sliding",
              "Hinged",
            ], (v) => setState(() => gateType = v!)),
          ]),
          _divider(),

          _row([
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

  // ─── MOBILE ─────────────────────────
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
          _mobileField("Project Name", projectNameController, isNumber: false),
          _mobileField("Location", locationController, isNumber: false),
          _mobileField("Boundary Length", boundaryLengthController),
          _mobileField("Fence Height", fenceHeightController),
          _mobileDrop("Fence Type", fenceType, [
            "Chain Link",
            "Barbed Wire",
            "Steel Panel",
            "Concrete Wall",
          ], (v) => setState(() => fenceType = v!)),
          _mobileField("Post Spacing", postSpacingController),
          _mobileField("Post Diameter", postDiameterController),
          _mobileField("Post Depth", postDepthController),
          _mobileField(
            "Concrete Grade",
            concreteGradeController,
            isNumber: false,
          ),
          _mobileField("Gate Count", gateCountController),
          _mobileField("Gate Width", gateWidthController),
          _mobileDrop("Gate Type", gateType, [
            "Sliding",
            "Hinged",
          ], (v) => setState(() => gateType = v!)),
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
                  "project": {
                    "name": projectNameController.text,
                    "location": locationController.text,
                  },
                  "boundary": {
                    "length": boundaryLengthController.text,
                    "height": fenceHeightController.text,
                  },
                  "fence": {
                    "type": fenceType,
                    "postSpacing": postSpacingController.text,
                  },
                  "structure": {
                    "postDiameter": postDiameterController.text,
                    "postDepth": postDepthController.text,
                    "concreteGrade": concreteGradeController.text,
                  },
                  "gate": {
                    "count": gateCountController.text,
                    "width": gateWidthController.text,
                    "type": gateType,
                  },
                  "drawing": {
                    "scale": scale,
                    "sheetSize": sheetSize,
                    "detailLevel": detailLevel,
                  },
                };

                try {
                  final response = await controller.generateDrawingFromInputs(
                    type: "fence",
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
            : const Text("Generate Fence Drawing"),
      ),
    );
  }
}
