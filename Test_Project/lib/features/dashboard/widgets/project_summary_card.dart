import 'package:flutter/material.dart';

import '../../../data/models/project_model.dart';

class ProjectSummaryCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectSummaryCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROJECT NAME
              Text(
                project.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// DESCRIPTION
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 12),

              /// PROJECT SIZE
              Row(
                children: [
                  const Icon(Icons.straighten, size: 18),

                  const SizedBox(width: 6),

                  Text("${project.length} × ${project.width}"),
                ],
              ),

              const SizedBox(height: 8),

              /// CREATED DATE
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),

                  const SizedBox(width: 6),

                  Text(project.createdAt.toLocal().toString().split(" ")[0]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
