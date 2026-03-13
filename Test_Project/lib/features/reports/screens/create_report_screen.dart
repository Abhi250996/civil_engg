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

  /// CONTROLLERS
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final filePathController = TextEditingController();
  final authorController = TextEditingController();
  final engineerController = TextEditingController();
  final organizationController = TextEditingController();
  final locationController = TextEditingController();

  /// DROPDOWNS
  String? reportType;
  String? category;
  String? status;

  /// CREATE REPORT
  void createReport() {
    if (!_formKey.currentState!.validate()) return;

    controller.createReport(
      projectId: "1", // Replace with real projectId
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

  int getColumns(double width) {
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  Widget field(Widget child) {
    return Padding(padding: const EdgeInsets.all(8), child: child);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Report")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BASIC INFO
                const Text(
                  "Report Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: getColumns(width),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  children: [
                    field(
                      TextFormField(
                        controller: titleController,
                        validator: (v) =>
                            Validators.validateRequired(v, "Title"),
                        decoration: const InputDecoration(
                          labelText: "Report Title",
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                    ),

                    field(
                      DropdownButtonFormField(
                        value: reportType,
                        items: const [
                          DropdownMenuItem(
                            value: "Structural",
                            child: Text("Structural"),
                          ),
                          DropdownMenuItem(
                            value: "Geotechnical",
                            child: Text("Geotechnical"),
                          ),
                          DropdownMenuItem(
                            value: "Environmental",
                            child: Text("Environmental"),
                          ),
                          DropdownMenuItem(
                            value: "Survey",
                            child: Text("Survey"),
                          ),
                          DropdownMenuItem(
                            value: "Inspection",
                            child: Text("Inspection"),
                          ),
                        ],
                        onChanged: (v) => setState(() => reportType = v),
                        decoration: const InputDecoration(
                          labelText: "Report Type",
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                    ),

                    field(
                      DropdownButtonFormField(
                        value: category,
                        items: const [
                          DropdownMenuItem(
                            value: "Engineering",
                            child: Text("Engineering"),
                          ),
                          DropdownMenuItem(
                            value: "Safety",
                            child: Text("Safety"),
                          ),
                          DropdownMenuItem(
                            value: "Construction",
                            child: Text("Construction"),
                          ),
                        ],
                        onChanged: (v) => setState(() => category = v),
                        decoration: const InputDecoration(
                          labelText: "Category",
                          prefixIcon: Icon(Icons.layers),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// AUTHOR INFO
                const Text(
                  "Author Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: getColumns(width),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  children: [
                    field(
                      TextFormField(
                        controller: authorController,
                        decoration: const InputDecoration(
                          labelText: "Author",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),

                    field(
                      TextFormField(
                        controller: engineerController,
                        decoration: const InputDecoration(
                          labelText: "Engineer",
                          prefixIcon: Icon(Icons.engineering),
                        ),
                      ),
                    ),

                    field(
                      TextFormField(
                        controller: organizationController,
                        decoration: const InputDecoration(
                          labelText: "Organization",
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// FILE
                Obx(() {
                  return TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: controller.selectedFilePath.value,
                    ),
                    validator: (v) => Validators.validateRequired(v, "File"),
                    decoration: InputDecoration(
                      labelText: "Report File",
                      prefixIcon: const Icon(Icons.attach_file),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.upload_file),
                        onPressed: controller.pickFile,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                /// LOCATION
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),

                const SizedBox(height: 16),

                /// DESCRIPTION
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),

                const SizedBox(height: 30),

                /// STATUS
                DropdownButtonFormField(
                  value: status,
                  items: const [
                    DropdownMenuItem(value: "Draft", child: Text("Draft")),
                    DropdownMenuItem(
                      value: "Submitted",
                      child: Text("Submitted"),
                    ),
                    DropdownMenuItem(
                      value: "Approved",
                      child: Text("Approved"),
                    ),
                  ],
                  onChanged: (v) => setState(() => status = v),
                  decoration: const InputDecoration(
                    labelText: "Status",
                    prefixIcon: Icon(Icons.check_circle),
                  ),
                ),

                const SizedBox(height: 30),

                /// BUTTON
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
    );
  }
}
