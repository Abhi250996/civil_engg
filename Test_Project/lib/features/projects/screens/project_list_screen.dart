import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';
import '../controllers/project_controller.dart';
import '../widgets/project_card.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final ProjectController controller = Get.find();

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadProjects();
  }

  int getCrossAxisCount(double width) {
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 700) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshProjects,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(RouteConstants.createProject);
        },
        icon: const Icon(Icons.add),
        label: const Text("New Project"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// SEARCH BAR
            TextField(
              controller: searchController,
              onChanged: controller.searchProjects,
              decoration: InputDecoration(
                hintText: "Search projects...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// PROJECT LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProjects.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "No projects found",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshProjects,

                  child: GridView.builder(
                    itemCount: controller.filteredProjects.length,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(width),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: width < 700 ? 1.1 : 1.4,
                    ),

                    itemBuilder: (context, index) {
                      ProjectModel project = controller.filteredProjects[index];

                      return ProjectCard(
                        project: project,

                        onTap: () {
                          controller.openProject(project);
                        },

                        onDelete: () {
                          controller.deleteProject(project.id);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
