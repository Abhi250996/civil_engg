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

  // Consistent Eye-Friendly Palette
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFE2E8F0);     // Darker matte gray (No reflection)
  static const Color cardBg = Color(0xFFF1F5F9);

  @override
  void initState() {
    super.initState();
    controller.loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue, // Colorful Header like Create Screen
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // Sets all icons in the AppBar to white
        ),        toolbarHeight: 50,
        title: const Text(
          "PROJECT INVENTORY",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.5
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Sync Data",
            icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 20),
            onPressed: controller.refreshProjects,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(RouteConstants.createProject),
        backgroundColor: primaryBlue,
        elevation: 4,
        icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
        label: const Text("NEW PROJECT", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: primaryBlue));
                  }

                  if (controller.filteredProjects.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshProjects,
                    color: primaryBlue,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: controller.filteredProjects.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 180, // Slimmer cards
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        ProjectModel project = controller.filteredProjects[index];
                        // ProjectCard will handle the dd-MM-yyyy internally
                        return ProjectCard(
                          project: project,
                          onTap: () => controller.openProject(project),
                          onDelete: () => controller.deleteProject(project.id),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
      color: primaryBlue.withOpacity(0.05), // Subtle blue tint
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: TextField(
            controller: searchController,
            onChanged: controller.searchProjects,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: "Search by project name, category or location...",
              hintStyle: TextStyle(color: primaryBlue.withOpacity(0.4), fontSize: 12),
              prefixIcon: const Icon(Icons.search_sharp, color: primaryBlue, size: 20),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: accentBlue, width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Icon(Icons.assignment_late_outlined, size: 70, color: primaryBlue.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "No Projects Found",
            style: TextStyle(color: primaryBlue.withOpacity(0.6), fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Try a different search or create a new entry.",
            style: TextStyle(color: primaryBlue.withOpacity(0.4), fontSize: 12),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: controller.refreshProjects,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("REFRESH LIST"),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryBlue,
              side: BorderSide(color: primaryBlue.withOpacity(0.2)),
            ),
          )
        ],
      ),
    );
  }
}