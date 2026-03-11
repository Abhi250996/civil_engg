import 'package:flutter/material.dart';

import '../../../data/models/project_model.dart';

class ProjectInfoWidget extends StatelessWidget {
  final ProjectModel project;

  const ProjectInfoWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROJECT NAME
            Text(
              project.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

            /// PROJECT SIZE
            Row(
              children: [
                const Icon(Icons.straighten, size: 18),

                const SizedBox(width: 8),

                Text("Size: ${project.length} × ${project.width}"),
              ],
            ),

            const SizedBox(height: 10),

            /// CREATED DATE
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),

                const SizedBox(width: 8),

                Text(project.createdAt.toLocal().toString().split(" ")[0]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
