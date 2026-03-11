import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();

  /// =========================
  /// CREATE PROJECT
  /// =========================

  void createProject() {
    if (!_formKey.currentState!.validate()) return;

    controller.createProject(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      length: double.parse(lengthController.text),
      width: double.parse(widthController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Project")),

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
                  /// PROJECT NAME
                  TextFormField(
                    controller: nameController,
                    validator: (value) =>
                        Validators.validateRequired(value, "Project Name"),
                    decoration: const InputDecoration(
                      labelText: "Project Name",
                      prefixIcon: Icon(Icons.folder),
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
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// LENGTH
                  TextFormField(
                    controller: lengthController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.validatePositiveNumber(value, "Length"),
                    decoration: const InputDecoration(
                      labelText: "Length",
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// WIDTH
                  TextFormField(
                    controller: widthController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.validatePositiveNumber(value, "Width"),
                    decoration: const InputDecoration(
                      labelText: "Width",
                      prefixIcon: Icon(Icons.square_foot),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// CREATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: createProject,
                      child: const Text("Create Project"),
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
