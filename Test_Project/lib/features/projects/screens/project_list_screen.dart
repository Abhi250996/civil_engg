import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../controllers/project_controller.dart';
import '../widgets/project_card.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.find();

    controller.loadProjects();

    return Scaffold(
      appBar: AppBar(title: const Text("Projects")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteConstants.createProject);
        },
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.projects.isEmpty) {
          return const Center(child: Text("No projects found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: controller.projects.length,

          itemBuilder: (context, index) {
            ProjectModel project = controller.projects[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProjectCard(
                project: project,
                onTap: () {
                  controller.openProject(project);
                },
                onDelete: () {
                  controller.deleteProject(project.id);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
