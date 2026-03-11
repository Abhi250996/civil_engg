import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectModel project = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROJECT NAME
            Text(
              project.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// DESCRIPTION
            Text(
              project.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// PROJECT SIZE
            Row(
              children: [
                const Icon(Icons.straighten),

                const SizedBox(width: 8),

                Text(
                  "Size: ${project.length} × ${project.width}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// CREATED DATE
            Row(
              children: [
                const Icon(Icons.calendar_today),

                const SizedBox(width: 8),

                Text(
                  "Created: ${project.createdAt.toLocal().toString().split(" ")[0]}",
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            _actionButton(
              title: "Calculations",
              icon: Icons.calculate,
              onTap: () {
                Get.toNamed(RouteConstants.calculationType, arguments: project);
              },
            ),

            const SizedBox(height: 12),

            _actionButton(
              title: "Field Tools",
              icon: Icons.construction,
              onTap: () {
                Get.toNamed(RouteConstants.fieldTools, arguments: project);
              },
            ),

            const SizedBox(height: 12),

            _actionButton(
              title: "Reports",
              icon: Icons.description,
              onTap: () {
                Get.toNamed(RouteConstants.reports, arguments: project);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// ACTION BUTTON
  /// =========================

  Widget _actionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(title),
        onPressed: onTap,
      ),
    );
  }
}
