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
  final ReportController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Theme Palette
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  // Controllers
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryBlue,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "DOCUMENT GENERATOR",
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ), // Desktop par window fit rakhega
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(
                    "Report Classification",
                    Icons.assignment_outlined,
                  ),
                  _buildResponsiveGrid(width, [
                    _inputField(
                      titleController,
                      "Report Title",
                      Icons.description,
                      true,
                    ),
                    _dropdownField(
                      "Report Type",
                      reportType,
                      Icons.category,
                      ["Structural", "Geotechnical", "Survey", "Inspection"],
                      (v) => setState(() => reportType = v),
                    ),
                    _dropdownField(
                      "Category",
                      category,
                      Icons.layers,
                      ["Engineering", "Safety", "Construction"],
                      (v) => setState(() => category = v),
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _sectionHeader("Stakeholder Details", Icons.badge_outlined),
                  _buildResponsiveGrid(width, [
                    _inputField(
                      authorController,
                      "Author Name",
                      Icons.person_outline,
                      false,
                    ),
                    _inputField(
                      engineerController,
                      "Lead Engineer",
                      Icons.engineering_outlined,
                      false,
                    ),
                    _inputField(
                      organizationController,
                      "Organization",
                      Icons.business,
                      false,
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _sectionHeader(
                    "Documentation & Metadata",
                    Icons.attachment_rounded,
                  ),
                  _buildFilePicker(),
                  const SizedBox(height: 16),
                  _buildResponsiveGrid(width, [
                    _inputField(
                      locationController,
                      "Site Location",
                      Icons.location_on_outlined,
                      false,
                    ),
                    _dropdownField(
                      "Document Status",
                      status,
                      Icons.check_circle_outline,
                      ["Draft", "Submitted", "Approved"],
                      (v) => setState(() => status = v),
                    ),
                  ]),

                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      "Executive Summary / Notes",
                      Icons.notes,
                    ),
                  ),

                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: accentBlue, size: 20),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveGrid(double width, List<Widget> children) {
    int columns = width > 900 ? 3 : (width > 600 ? 2 : 1);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 75,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: accentBlue, size: 20),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: primaryBlue.withOpacity(0.4), fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentBlue, width: 2),
      ),
    );
  }

  Widget _inputField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    bool req,
  ) {
    return TextFormField(
      controller: ctrl,
      validator: req ? (v) => Validators.validateRequired(v, label) : null,
      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _dropdownField(
    String label,
    String? val,
    IconData icon,
    List<String> items,
    Function(String?) onChg,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: val,
      onChanged: onChg,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _buildFilePicker() {
    return Obx(
      () => TextFormField(
        readOnly: true,
        controller: TextEditingController(
          text: controller.selectedFilePath.value,
        ),
        decoration:
            _inputDecoration(
              "Attach Technical Document",
              Icons.attach_file,
            ).copyWith(
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: accentBlue,
                ),
                onPressed: controller.pickFile,
              ),
            ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [primaryBlue, accentBlue]),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: createReport,
        child: const Text(
          "GENERATE OFFICIAL REPORT",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
