import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/validators.dart';
import '../controllers/project_controller.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final ProjectController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFE2E8F0);

  // Controllers - Synced with all fields in Detail Screen
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final budgetController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final siteAreaController = TextEditingController();      // Missing Field
  final elevationController = TextEditingController();     // Missing Field
  final latitudeController = TextEditingController();      // Missing Field
  final longitudeController = TextEditingController();     // Missing Field
  final contractorController = TextEditingController();    // Missing Field
  final consultantController = TextEditingController();    // Missing Field
  final descriptionController = TextEditingController();
  final dateDisplayController = TextEditingController();
  final completionDateController = TextEditingController(); // Missing Field

  String? projectCategory, projectSubType, soilType, foundationType, structureType, materialGrade, projectStatus, projectStage;
  DateTime? selectedStartDate, selectedCompletionDate;

  // Generic Date Picker
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
          dateDisplayController.text = DateFormat('dd-MM-yyyy').format(picked);
        } else {
          selectedCompletionDate = picked;
          completionDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    controller.createProject(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      startDate: selectedStartDate,
      completionDate: selectedCompletionDate, // Added
      location: locationController.text.trim(),
      budget: double.tryParse(budgetController.text) ?? 0,
      length: double.tryParse(lengthController.text) ?? 0,
      width: double.tryParse(widthController.text) ?? 0,
      siteArea: double.tryParse(siteAreaController.text) ?? 0, // Added
      elevation: double.tryParse(elevationController.text) ?? 0, // Added
      latitude: double.tryParse(latitudeController.text) ?? 0, // Added
      longitude: double.tryParse(longitudeController.text) ?? 0, // Added
      contractor: contractorController.text.trim(), // Added
      consultant: consultantController.text.trim(), // Added
      projectCategory: projectCategory,
      projectSubType: projectSubType, // Added
      soilType: soilType,
      foundationType: foundationType,
      structureType: structureType,
      materialGrade: materialGrade, // Added
      projectStatus: projectStatus, // Added
      projectStage: projectStage,   // Added
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 1100 ? 4 : (screenWidth > 700 ? 2 : 1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("FULL PROJECT DATA ENTRY", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader("1. BASIC INFO & TIMELINE"),
                  _buildGrid(crossAxisCount, [
                    _inputField(nameController, "Project Name*", Icons.folder, true, Colors.orange),
                    _dateField("Start Date*", dateDisplayController, true),
                    _dateField("Target Completion", completionDateController, false),
                    _dropdownField("Category", projectCategory, Icons.category, ["Building", "Bridge", "Road", "Dam"], (v) => setState(() => projectCategory = v), accentBlue),
                    _inputField(locationController, "Location", Icons.pin_drop, false, Colors.green),
                    _inputField(budgetController, "Budget (₹)", Icons.payments, false, Colors.teal, isNumber: true),
                  ]),

                  _sectionHeader("2. SITE & ENGINEERING DETAILS"),
                  _buildGrid(crossAxisCount, [
                    _inputField(siteAreaController, "Site Area (m²)", Icons.area_chart, false, Colors.blueGrey, isNumber: true),
                    _inputField(lengthController, "Length (m)", Icons.straighten, false, Colors.purple, isNumber: true),
                    _inputField(widthController, "Width (m)", Icons.square_foot, false, Colors.indigo, isNumber: true),
                    _inputField(elevationController, "Elevation (m)", Icons.height, false, Colors.cyan, isNumber: true),
                    _dropdownField("Soil Type", soilType, Icons.terrain, ["Clay", "Rock", "Sand"], (v) => setState(() => soilType = v), Colors.brown),
                    _dropdownField("Structure", structureType, Icons.apartment, ["RCC", "Steel", "Composite"], (v) => setState(() => structureType = v), Colors.deepOrange),
                  ]),

                  _sectionHeader("3. COORDINATES & MANAGEMENT"),
                  _buildGrid(crossAxisCount, [
                    _inputField(latitudeController, "Latitude", Icons.location_searching, false, Colors.red),
                    _inputField(longitudeController, "Longitude", Icons.location_searching, false, Colors.red),
                    _inputField(contractorController, "Contractor", Icons.business, false, Colors.blue),
                    _inputField(consultantController, "Consultant", Icons.person_search, false, Colors.indigo),
                    _dropdownField("Status", projectStatus, Icons.check_circle, ["Active", "On Hold", "Closed"], (v) => setState(() => projectStatus = v), Colors.green),
                    _dropdownField("Stage", projectStage, Icons.pending_actions, ["Planning", "Design", "Execution"], (v) => setState(() => projectStage = v), Colors.orange),
                  ]),

                  _sectionHeader("4. TECHNICAL NOTES"),
                  SizedBox(
                    height: 120,
                    child: TextFormField(
                      controller: descriptionController,
                      maxLines: null, expands: true,
                      decoration: _inputDecoration("Add specifications...", Icons.edit_note, accentBlue),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("* Mandatory Fields", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      _buildSubmitButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: Text(title, style: const TextStyle(color: primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGrid(int count, List<Widget> children) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count, crossAxisSpacing: 10, mainAxisSpacing: 8, mainAxisExtent: 55,
      ),
      children: children,
    );
  }

  Widget _dateField(String label, TextEditingController ctrl, bool isStart) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStart),
      child: AbsorbPointer(child: _inputField(ctrl, label, Icons.calendar_month, isStart, Colors.redAccent)),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, Color iColor) {
    return InputDecoration(
      labelText: label, prefixIcon: Icon(icon, color: iColor, size: 16),
      filled: true, fillColor: Colors.white,
      labelStyle: const TextStyle(fontSize: 10),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: accentBlue)),
    );
  }

  Widget _inputField(TextEditingController ctrl, String label, IconData icon, bool req, Color iColor, {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl, keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: req ? (v) => Validators.validateRequired(v, label) : null,
      style: const TextStyle(fontSize: 12),
      decoration: _inputDecoration(label, icon, iColor),
    );
  }

  Widget _dropdownField(String label, String? val, IconData icon, List<String> items, Function(String?) onChng, Color iColor) {
    return DropdownButtonFormField<String>(
      value: val, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChng, decoration: _inputDecoration(label, icon, iColor),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
      onPressed: _handleSave,
      child: const Text("SAVE COMPLETE DATA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildLoadingOverlay() {
    return Obx(() => controller.isLoading.value
        ? Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: primaryBlue)))
        : const SizedBox.shrink());
  }
}