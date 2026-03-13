import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';

class ProjectInfoWidget extends StatelessWidget {
  final ProjectModel project;

  const ProjectInfoWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                const Icon(Icons.account_tree, color: Colors.blue, size: 28),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION
            Text(
              project.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 10),

            /// PROJECT CATEGORY
            _infoRow(
              Icons.category,
              "Category",
              project.projectCategory ?? "-",
            ),

            /// LOCATION
            _infoRow(Icons.location_on, "Location", project.location ?? "-"),

            /// SOIL TYPE
            _infoRow(Icons.terrain, "Soil", project.soilType ?? "-"),

            /// FOUNDATION
            _infoRow(
              Icons.foundation,
              "Foundation",
              project.foundationType ?? "-",
            ),

            /// SIZE
            if (project.length != null && project.width != null)
              _infoRow(
                Icons.straighten,
                "Size",
                "${project.length} × ${project.width}",
              ),

            /// CREATED DATE
            _infoRow(
              Icons.calendar_today,
              "Created",
              project.createdAt.toLocal().toString().split(" ")[0],
            ),

            const SizedBox(height: 10),

            /// PROJECT STATUS
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
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Row(
        children: [
          Icon(icon, size: 18),

          const SizedBox(width: 8),

          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
