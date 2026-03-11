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

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController filePathController = TextEditingController();

  /// =========================
  /// CREATE REPORT
  /// =========================

  void createReport() {
    if (!_formKey.currentState!.validate()) return;

    controller.createReport(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      filePath: filePathController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Report")),

      body: Center(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// REPORT TITLE
                  TextFormField(
                    controller: titleController,
                    validator: (value) =>
                        Validators.validateRequired(value, "Title"),
                    decoration: const InputDecoration(
                      labelText: "Report Title",
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// DESCRIPTION
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) =>
                        Validators.validateRequired(value, "Description"),
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// FILE PATH
                  TextFormField(
                    controller: filePathController,
                    validator: (value) =>
                        Validators.validateRequired(value, "File Path"),
                    decoration: const InputDecoration(
                      labelText: "File Path",
                      prefixIcon: Icon(Icons.folder),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// CREATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: createReport,
                      child: const Text("Create Report"),
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
}
