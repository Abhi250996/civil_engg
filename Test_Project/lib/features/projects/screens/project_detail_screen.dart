import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  // Theme Tokens
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC);     // Soft White
  static const Color borderColor = Color(0xFFE5E7EB); // Light Gray

  @override
  Widget build(BuildContext context) {
    final ProjectModel project = Get.arguments;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryBlue, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          project.name.toUpperCase(),
          style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200), // Desktop par window fit rakhega
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildProjectHeader(project),
                  const SizedBox(height: 24),

                  // Detail Grid
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400, // Card width restrict for Desktop
                      mainAxisExtent: 260,     // Card height lock
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    children: [
                      _infoCard(
                        title: "Basic Info",
                        icon: Icons.info_outline,
                        children: [
                          _infoRow("Category", project.projectCategory ?? "-"),
                          _infoRow("Subtype", project.projectSubType ?? "-"),
                          _infoRow("Location", project.location ?? "-"),
                          _infoRow("Budget", "₹ ${project.budget?.toString() ?? "-"}"),
                        ],
                      ),
                      _infoCard(
                        title: "Site Details",
                        icon: Icons.map_outlined,
                        children: [
                          _infoRow("Site Area", "${project.siteArea ?? "-"} m²"),
                          _infoRow("Dimensions", "${project.length}m x ${project.width}m"),
                          _infoRow("Elevation", "${project.elevation ?? "-"} m"),
                          _infoRow("Coordinates", "${project.latitude}, ${project.longitude}"),
                        ],
                      ),
                      _infoCard(
                        title: "Engineering",
                        icon: Icons.architecture,
                        children: [
                          _infoRow("Soil Type", project.soilType ?? "-"),
                          _infoRow("Foundation", project.foundationType ?? "-"),
                          _infoRow("Structure", project.structureType ?? "-"),
                          _infoRow("Material", project.materialGrade ?? "-"),
                        ],
                      ),
                      _infoCard(
                        title: "Management",
                        icon: Icons.business_center_outlined,
                        children: [
                          _infoRow("Contractor", project.contractor ?? "-"),
                          _infoRow("Consultant", project.consultant ?? "-"),
                          _infoRow("Status", project.projectStatus ?? "Active"),
                          _infoRow("Stage", project.projectStage ?? "Planning"),
                        ],
                      ),
                      _infoCard(
                        title: "Timeline",
                        icon: Icons.calendar_today_outlined,
                        children: [
                          _infoRow("Start Date", project.startDate?.toLocal().toString().split(" ")[0] ?? "-"),
                          _infoRow("Target Date", project.completionDate?.toLocal().toString().split(" ")[0] ?? "-"),
                          _infoRow("Created", project.createdAt.toLocal().toString().split(" ")[0]),
                        ],
                      ),
                      _actionCard(project),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildNotesCard(project.description),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildProjectHeader(ProjectModel project) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [primaryBlue, Color(0xFF162D6D)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: accentBlue, borderRadius: BorderRadius.circular(4)),
            child: Text(
              project.projectStatus?.toUpperCase() ?? "IN PROGRESS",
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.name,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            "ID: PRJ-${project.name.hashCode.toString().substring(0, 5)}",
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentBlue, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: primaryBlue.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNotesCard(String notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ENGINEER NOTES", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(notes.isEmpty ? "No notes added for this project." : notes, style: TextStyle(color: primaryBlue.withOpacity(0.7), fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _actionCard(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PROJECT TOOLS", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider(height: 24),
          _toolBtn("Calculations", Icons.calculate_outlined, () => Get.toNamed(RouteConstants.calculationType, arguments: project)),
          const SizedBox(height: 12),
          _toolBtn("Field Tools", Icons.construction, () => Get.toNamed(RouteConstants.fieldTools, arguments: project)),
          const SizedBox(height: 12),
          _toolBtn("Export Report", Icons.description_outlined, () => Get.toNamed(RouteConstants.reports, arguments: project)),
        ],
      ),
    );
  }

  Widget _toolBtn(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}