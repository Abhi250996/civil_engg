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
  final controller = Get.find<ProjectController>();
  final _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  /// ================= CONTROLLERS =================
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final budgetController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final siteAreaController = TextEditingController();
  final elevationController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final contractorController = TextEditingController();
  final consultantController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();

  String? projectCategory, soilType, structureType, projectStatus, projectStage;

  DateTime? startDate, endDate;

  /// ================= DATE =================
  Future<void> pickDate(bool isStart) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (d != null) {
      setState(() {
        if (isStart) {
          startDate = d;
          startDateCtrl.text = DateFormat('dd-MM-yyyy').format(d);
        } else {
          endDate = d;
          endDateCtrl.text = DateFormat('dd-MM-yyyy').format(d);
        }
      });
    }
  }

  /// ================= SAVE =================
  void save() {
    if (!_formKey.currentState!.validate()) return;

    controller.createProject(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(), // ✅ FIXED
      startDate: startDate,
      completionDate: endDate,
      location: locationController.text.trim(),
      budget: double.tryParse(budgetController.text) ?? 0,
      length: double.tryParse(lengthController.text) ?? 0,
      width: double.tryParse(widthController.text) ?? 0,
      siteArea: double.tryParse(siteAreaController.text) ?? 0,
      elevation: double.tryParse(elevationController.text) ?? 0,
      latitude: double.tryParse(latitudeController.text) ?? 0,
      longitude: double.tryParse(longitudeController.text) ?? 0,
      contractor: contractorController.text.trim(),
      consultant: consultantController.text.trim(),
      projectCategory: projectCategory,
      soilType: soilType,
      structureType: structureType,
      projectStatus: projectStatus,
      projectStage: projectStage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// HEADER
                  Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text(
                        "CREATE PROJECT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// MAIN CARD
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _section("Basic Info", [
                                _field(nameController, "Project Name*", true),
                                _date(startDateCtrl, "Start Date*", true),
                                _date(endDateCtrl, "Completion", false),
                                _field(locationController, "Location", false),
                                _field(
                                  budgetController,
                                  "Budget",
                                  false,
                                  isNumber: true,
                                ),
                              ], isDesktop),

                              const SizedBox(height: 20),

                              _section("Site", [
                                _field(siteAreaController, "Site Area", false),
                                _field(lengthController, "Length", false),
                                _field(widthController, "Width", false),
                                _field(elevationController, "Elevation", false),
                              ], isDesktop),

                              const SizedBox(height: 20),

                              _section("Management", [
                                _field(
                                  contractorController,
                                  "Contractor",
                                  false,
                                ),
                                _field(
                                  consultantController,
                                  "Consultant",
                                  false,
                                ),
                                _dropdown(
                                  "Status",
                                  projectStatus,
                                  ["Active", "On Hold", "Closed"],
                                  (v) => setState(() => projectStatus = v),
                                ),
                                _dropdown(
                                  "Stage",
                                  projectStage,
                                  ["Planning", "Design", "Execution"],
                                  (v) => setState(() => projectStage = v),
                                ),
                              ], isDesktop),

                              const SizedBox(height: 20),

                              /// DESCRIPTION
                              TextFormField(
                                controller: descriptionController,
                                validator: (v) => Validators.validateRequired(
                                  v,
                                  "Description",
                                ),
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: "Description*",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: save,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentBlue,
                                  ),
                                  child: const Text(
                                    "SAVE PROJECT",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= HELPERS =================

  Widget _section(String title, List<Widget> fields, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: isDesktop ? 2 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: isDesktop ? 8 : 3.5,
          children: fields,
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    bool req, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: req ? (v) => Validators.validateRequired(v, label) : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField(
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _date(TextEditingController ctrl, String label, bool isStart) {
    return GestureDetector(
      onTap: () => pickDate(isStart),
      child: AbsorbPointer(child: _field(ctrl, label, false)),
    );
  }
}
