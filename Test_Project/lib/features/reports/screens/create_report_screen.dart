import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../controllers/report_controller.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final controller = Get.find<ReportController>();
  final _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorController = TextEditingController();
  final engineerController = TextEditingController();
  final organizationController = TextEditingController();
  final locationController = TextEditingController();

  String? reportType, category, status;

  void createReport() {
    if (!_formKey.currentState!.validate()) return;

    controller.createReport(
      projectId: "1",
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      reportType: reportType ?? "General",
      filePath: controller.selectedFilePath.value,
      category: category,
      author: authorController.text,
      engineer: engineerController.text,
      organization: organizationController.text,
      location: locationController.text,
      status: status,
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
            constraints: const BoxConstraints(maxWidth: 1000),

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
                        "CREATE REPORT",
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
                              _section("Report Info", [
                                _field(titleController, "Title*", true),
                                _dropdown(
                                  "Type",
                                  reportType,
                                  ["Structural", "Survey", "Inspection"],
                                  (v) => setState(() => reportType = v),
                                ),
                                _dropdown(
                                  "Category",
                                  category,
                                  ["Engineering", "Safety"],
                                  (v) => setState(() => category = v),
                                ),
                              ], isDesktop),

                              const SizedBox(height: 20),

                              _section("Stakeholders", [
                                _field(authorController, "Author", false),
                                _field(engineerController, "Engineer", false),
                                _field(
                                  organizationController,
                                  "Organization",
                                  false,
                                ),
                              ], isDesktop),

                              const SizedBox(height: 20),

                              _filePicker(),

                              const SizedBox(height: 20),

                              _section("Metadata", [
                                _field(locationController, "Location", false),
                                _dropdown("Status", status, [
                                  "Draft",
                                  "Submitted",
                                  "Approved",
                                ], (v) => setState(() => status = v)),
                              ], isDesktop),

                              const SizedBox(height: 20),

                              /// DESCRIPTION
                              TextFormField(
                                controller: descriptionController,
                                validator: (v) => Validators.validateRequired(
                                  v,
                                  "Description",
                                ),
                                maxLines: 3,
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
                                  onPressed: createReport,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentBlue,
                                  ),
                                  child: const Text("GENERATE REPORT"),
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
          childAspectRatio: 3.5,
          children: fields,
        ),
      ],
    );
  }

  Widget _field(TextEditingController c, String label, bool req) {
    return TextFormField(
      controller: c,
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

  Widget _filePicker() {
    return Obx(
      () => TextFormField(
        readOnly: true,
        controller: TextEditingController(
          text: controller.selectedFilePath.value,
        ),
        decoration: InputDecoration(
          labelText: "Attach File",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.upload),
            onPressed: controller.pickFile,
          ),
        ),
      ),
    );
  }
}
