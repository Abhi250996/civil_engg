import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  int getCrossAxisCount(double width) {
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final ProjectModel project = Get.arguments;

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getCrossAxisCount(width),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: width < 800 ? 1.4 : 2.2,
          ),

          children: [
            /// PROJECT INFORMATION
            _infoCard(
              title: "Project Information",
              children: [
                _infoRow("Name", project.name),
                _infoRow("Category", project.projectCategory ?? "-"),
                _infoRow("Subtype", project.projectSubType ?? "-"),
                _infoRow("Location", project.location ?? "-"),
                _infoRow("Budget", project.budget?.toString() ?? "-"),
              ],
            ),

            /// SITE DETAILS
            _infoCard(
              title: "Site Details",
              children: [
                _infoRow("Site Area", project.siteArea?.toString() ?? "-"),
                _infoRow("Length", project.length?.toString() ?? "-"),
                _infoRow("Width", project.width?.toString() ?? "-"),
                _infoRow("Elevation", project.elevation?.toString() ?? "-"),
                _infoRow("Latitude", project.latitude?.toString() ?? "-"),
                _infoRow("Longitude", project.longitude?.toString() ?? "-"),
              ],
            ),

            /// ENGINEERING PARAMETERS
            _infoCard(
              title: "Engineering Parameters",
              children: [
                _infoRow("Soil Type", project.soilType ?? "-"),
                _infoRow("Foundation", project.foundationType ?? "-"),
                _infoRow("Structure", project.structureType ?? "-"),
                _infoRow("Material Grade", project.materialGrade ?? "-"),
                _infoRow("Seismic Zone", project.seismicZone ?? "-"),
                _infoRow("Design Code", project.designCode ?? "-"),
              ],
            ),

            /// PROJECT MANAGEMENT
            _infoCard(
              title: "Project Management",
              children: [
                _infoRow("Contractor", project.contractor ?? "-"),
                _infoRow("Consultant", project.consultant ?? "-"),
                _infoRow("Status", project.projectStatus ?? "-"),
                _infoRow("Stage", project.projectStage ?? "-"),
              ],
            ),

            /// TIMELINE
            _infoCard(
              title: "Timeline",
              children: [
                _infoRow(
                  "Start Date",
                  project.startDate?.toLocal().toString().split(" ")[0] ?? "-",
                ),
                _infoRow(
                  "Completion",
                  project.completionDate?.toLocal().toString().split(" ")[0] ??
                      "-",
                ),
                _infoRow(
                  "Created",
                  project.createdAt.toLocal().toString().split(" ")[0],
                ),
              ],
            ),

            /// DESCRIPTION
            _infoCard(
              title: "Engineer Notes",
              children: [
                Text(project.description, style: const TextStyle(fontSize: 14)),
              ],
            ),

            /// PROJECT TOOLS
            _actionCard(project),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// INFO CARD
  /// =========================

  Widget _infoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            ...children,
          ],
        ),
      ),
    );
  }

  /// =========================
  /// INFO ROW
  /// =========================

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  /// =========================
  /// ACTION CARD
  /// =========================

  Widget _actionCard(ProjectModel project) {
    return Card(
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Project Tools",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            const SizedBox(height: 10),

            _actionButton(
              title: "Calculations",
              icon: Icons.calculate,
              onTap: () {
                Get.toNamed(RouteConstants.calculationType, arguments: project);
              },
            ),

            const SizedBox(height: 10),

            _actionButton(
              title: "Field Tools",
              icon: Icons.construction,
              onTap: () {
                Get.toNamed(RouteConstants.fieldTools, arguments: project);
              },
            ),

            const SizedBox(height: 10),

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
