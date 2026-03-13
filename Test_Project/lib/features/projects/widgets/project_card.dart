import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// HEADER
              Row(
                children: [
                  const Icon(Icons.account_tree, size: 32, color: Colors.blue),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// CATEGORY
              _info("Category", project.projectCategory ?? "-"),

              /// LOCATION
              _info("Location", project.location ?? "-"),

              /// SOIL
              _info("Soil", project.soilType ?? "-"),

              /// FOUNDATION
              _info("Foundation", project.foundationType ?? "-"),

              /// SIZE
              if (project.length != null && project.width != null)
                _info("Size", "${project.length} × ${project.width}"),

              const Spacer(),

              /// STATUS
              if (project.projectStatus != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),

                  child: Text(
                    project.projectStatus!,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),

      child: Text("$label: $value", style: const TextStyle(fontSize: 13)),
    );
  }
}
