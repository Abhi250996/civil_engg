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

  /// CONTROLLERS
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final budgetController = TextEditingController();
  final locationController = TextEditingController();

  /// DROPDOWNS
  String? projectCategory;
  String? soilType;
  String? foundationType;
  String? structureType;

  /// CREATE PROJECT
  void createProject() {
    if (!_formKey.currentState!.validate()) return;

    controller.createProject(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      length: double.tryParse(lengthController.text),
      width: double.tryParse(widthController.text),
      budget: double.tryParse(budgetController.text),
      location: locationController.text,
      soilType: soilType,
      foundationType: foundationType,
      structureType: structureType,
      projectCategory: projectCategory,
    );
  }

  /// RESPONSIVE GRID
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
      appBar: AppBar(title: const Text("Create Project")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PROJECT BASIC INFO
                const Text(
                  "Project Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: getColumns(width),
                  childAspectRatio: 3.2,
                  children: [
                    /// PROJECT NAME
                    field(
                      TextFormField(
                        controller: nameController,
                        validator: (v) =>
                            Validators.validateRequired(v, "Project Name"),
                        decoration: const InputDecoration(
                          labelText: "Project Name",
                          prefixIcon: Icon(Icons.folder),
                        ),
                      ),
                    ),

                    /// PROJECT CATEGORY
                    field(
                      DropdownButtonFormField(
                        value: projectCategory,
                        items: const [
                          DropdownMenuItem(
                            value: "Building",
                            child: Text("Building"),
                          ),
                          DropdownMenuItem(
                            value: "Bridge",
                            child: Text("Bridge"),
                          ),
                          DropdownMenuItem(value: "Dam", child: Text("Dam")),
                          DropdownMenuItem(
                            value: "PowerPlant",
                            child: Text("Power Plant"),
                          ),
                          DropdownMenuItem(
                            value: "Road",
                            child: Text("Road / Highway"),
                          ),
                          DropdownMenuItem(
                            value: "Railway",
                            child: Text("Railway"),
                          ),
                          DropdownMenuItem(
                            value: "Airport",
                            child: Text("Airport"),
                          ),
                          DropdownMenuItem(
                            value: "Industrial",
                            child: Text("Industrial"),
                          ),
                          DropdownMenuItem(
                            value: "Government",
                            child: Text("Government"),
                          ),
                        ],
                        onChanged: (v) => setState(() => projectCategory = v),
                        decoration: const InputDecoration(
                          labelText: "Project Category",
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                    ),

                    /// LOCATION
                    field(
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: "Location",
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                    ),

                    /// BUDGET
                    field(
                      TextFormField(
                        controller: budgetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Budget",
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// SITE DETAILS
                const Text(
                  "Site Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: getColumns(width),
                  childAspectRatio: 3.2,
                  children: [
                    field(
                      TextFormField(
                        controller: lengthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Length (m)",
                          prefixIcon: Icon(Icons.straighten),
                        ),
                      ),
                    ),

                    field(
                      TextFormField(
                        controller: widthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Width (m)",
                          prefixIcon: Icon(Icons.square_foot),
                        ),
                      ),
                    ),

                    field(
                      DropdownButtonFormField(
                        value: soilType,
                        items: const [
                          DropdownMenuItem(value: "Clay", child: Text("Clay")),
                          DropdownMenuItem(value: "Sand", child: Text("Sand")),
                          DropdownMenuItem(
                            value: "Gravel",
                            child: Text("Gravel"),
                          ),
                          DropdownMenuItem(value: "Rock", child: Text("Rock")),
                        ],
                        onChanged: (v) => setState(() => soilType = v),
                        decoration: const InputDecoration(
                          labelText: "Soil Type",
                          prefixIcon: Icon(Icons.terrain),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// STRUCTURAL DETAILS
                const Text(
                  "Structural Parameters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: getColumns(width),
                  childAspectRatio: 3.2,
                  children: [
                    field(
                      DropdownButtonFormField(
                        value: foundationType,
                        items: const [
                          DropdownMenuItem(
                            value: "Shallow",
                            child: Text("Shallow"),
                          ),
                          DropdownMenuItem(value: "Pile", child: Text("Pile")),
                          DropdownMenuItem(value: "Raft", child: Text("Raft")),
                        ],
                        onChanged: (v) => setState(() => foundationType = v),
                        decoration: const InputDecoration(
                          labelText: "Foundation Type",
                          prefixIcon: Icon(Icons.foundation),
                        ),
                      ),
                    ),

                    field(
                      DropdownButtonFormField(
                        value: structureType,
                        items: const [
                          DropdownMenuItem(
                            value: "Concrete",
                            child: Text("Concrete Structure"),
                          ),
                          DropdownMenuItem(
                            value: "Steel",
                            child: Text("Steel Structure"),
                          ),
                          DropdownMenuItem(
                            value: "Composite",
                            child: Text("Composite"),
                          ),
                        ],
                        onChanged: (v) => setState(() => structureType = v),
                        decoration: const InputDecoration(
                          labelText: "Structure Type",
                          prefixIcon: Icon(Icons.construction),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// DESCRIPTION
                TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Engineer Notes",
                    prefixIcon: Icon(Icons.description),
                  ),
                ),

                const SizedBox(height: 30),

                /// BUTTON
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
    );
  }
}
