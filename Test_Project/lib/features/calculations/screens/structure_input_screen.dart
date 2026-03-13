import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/route_constants.dart';
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
  static const accentBlue = Color(0xFF3B82F6);
  static const bgColor = Color(0xFFF8FAFC);
  static const borderColor = Color(0xFFE5E7EB);

  // Controllers
  final projectNameController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final floorsController = TextEditingController(text: "1");
  final frontSetbackController = TextEditingController(text: "1.5");
  final sideSetbackController = TextEditingController(text: "1.0");
  final roomsController = TextEditingController(text: "2");

  // Specific Controllers for Road/Industry
  final thicknessController = TextEditingController(text: "200"); // mm
  final loadController = TextEditingController(text: "50"); // Tons

  String unitSystem = "Metric";
  String orientation = "North";
  late String structureType;

  @override
  void initState() {
    super.initState();
    // Getting type from arguments
    structureType = (Get.arguments?["type"] ?? "building").toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 60,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryBlue, size: 22),
          onPressed: () => Get.back(),
        ),
        title: Text('${structureType.toUpperCase()} DESIGNER',
            style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 16)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 1100 : 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("General Information"),
                      _buildResponsiveLayout(
                        isDesktop: isDesktop,
                        children: [
                          _buildTextField(projectNameController, "Project Name", Icons.business),
                          _buildDropdown("Unit System", unitSystem, ["Metric", "Imperial"], (v) => setState(() => unitSystem = v!)),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // --- DYNAMIC FILTERING BASED ON TYPE ---
                      if (structureType == "building") ..._buildHouseInputs(isDesktop),
                      if (structureType == "road") ..._buildRoadInputs(isDesktop),
                      if (structureType == "factory" || structureType == "plant") ..._buildIndustrialInputs(isDesktop),

                      const SizedBox(height: 40),

                      // Status Message display
                      Obx(() => controller.statusMessage.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(child: Text(controller.statusMessage.value, style: const TextStyle(color: accentBlue, fontWeight: FontWeight.bold))),
                      )
                          : const SizedBox.shrink()),

                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: _buildGenerateButton(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- HOUSE SPECIFIC INPUTS ---
  List<Widget> _buildHouseInputs(bool isDesktop) {
    return [
      _sectionTitle("Plot Dimensions & Orientation"),
      _buildResponsiveLayout(isDesktop: isDesktop, children: [
        _buildTextField(lengthController, "Length (m)", Icons.straighten, isNum: true),
        _buildTextField(widthController, "Width (m)", Icons.square_foot, isNum: true),
        _buildDropdown("Facing", orientation, ["North", "South", "East", "West"], (v) => setState(() => orientation = v!)),
      ]),
      const SizedBox(height: 25),
      _sectionTitle("Setbacks & Requirements"),
      _buildResponsiveLayout(isDesktop: isDesktop, children: [
        _buildTextField(frontSetbackController, "Front (m)", Icons.door_front_door, isNum: true),
        _buildTextField(floorsController, "Floors", Icons.layers, isNum: true),
        _buildTextField(roomsController, "BHK", Icons.bed, isNum: true),
      ]),
    ];
  }

  // --- ROAD SPECIFIC INPUTS ---
  List<Widget> _buildRoadInputs(bool isDesktop) {
    return [
      _sectionTitle("Road Geometry"),
      _buildResponsiveLayout(isDesktop: isDesktop, children: [
        _buildTextField(lengthController, "Total Length (km)", Icons.add_road, isNum: true),
        _buildTextField(widthController, "Carriageway Width (m)", Icons.width_full, isNum: true),
        _buildTextField(thicknessController, "Pavement Thick (mm)", Icons.layers_outlined, isNum: true),
      ]),
    ];
  }

  // --- INDUSTRIAL SPECIFIC INPUTS ---
  List<Widget> _buildIndustrialInputs(bool isDesktop) {
    return [
      _sectionTitle("Plant Capacity & Area"),
      _buildResponsiveLayout(isDesktop: isDesktop, children: [
        _buildTextField(lengthController, "Shed Length (m)", Icons.factory, isNum: true),
        _buildTextField(widthController, "Shed Width (m)", Icons.aspect_ratio, isNum: true),
        _buildTextField(loadController, "Floor Load (T/m2)", Icons.fitness_center, isNum: true),
      ]),
    ];
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildResponsiveLayout({required bool isDesktop, required List<Widget> children}) {
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
        child: Row(children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: c))).toList()),
      );
    } else {
      return Column(children: children.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList());
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title.toUpperCase(), style: const TextStyle(color: primaryBlue, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {bool isNum = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryBlue),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, size: 20, color: accentBlue),
        labelStyle: TextStyle(color: primaryBlue.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: borderColor, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: accentBlue, width: 2)),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      iconSize: 24,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryBlue),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(color: primaryBlue.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: borderColor, width: 1.5)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Obx(() => ElevatedButton.icon(
        icon: controller.isLoading.value
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.architecture_rounded, size: 24),
        label: Text(
            controller.isLoading.value ? "PROCESSING..." : "GENERATE PROFESSIONAL PLAN",
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)
        ),
        onPressed: controller.isLoading.value ? null : () {
          if (_formKey.currentState!.validate()) {
            // DATA COLLECTION START
            Map<String, dynamic> dataToSave = {
              "projectName": projectNameController.text,
              "unit": unitSystem,
              "length": lengthController.text,
              "width": widthController.text,
            };

            // Adding type specific data
            if (structureType == "building") {
              dataToSave.addAll({
                "orientation": orientation,
                "frontSetback": frontSetbackController.text,
                "sideSetback": sideSetbackController.text,
                "floors": floorsController.text,
                "rooms": roomsController.text,
              });
            } else if (structureType == "road") {
              dataToSave.addAll({
                "thickness": thicknessController.text,
              });
            } else if (structureType == "factory" || structureType == "plant") {
              dataToSave.addAll({
                "load": loadController.text,
              });
            }

            // FINAL CALL TO CONTROLLER
            controller.generateDrawingFromInputs(
                type: structureType,
                inputData: dataToSave
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      )),
    );
  }
}