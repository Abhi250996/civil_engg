import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';

class ProjectInfoWidget extends StatelessWidget {
  final ProjectModel project;

  const ProjectInfoWidget({super.key, required this.project});

  // Brand Palette
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color borderColor = Color(0xFFE5E7EB); // Light Gray

  @override
  Widget build(BuildContext context) {
    return Center( // Desktop/Web alignment fix
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600), // Card ko bahut wide hone se rokne ke liye
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Window fit ke liye
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP HEADER SECTION
              _buildHeader(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// DESCRIPTION / ENGINEER NOTES
                    Text(
                      "PROJECT OVERVIEW",
                      style: TextStyle(
                        color: primaryBlue.withOpacity(0.5),
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: primaryBlue,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),

                    /// SPECIFICATIONS GRID (Optimized for space)
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _infoBlock(Icons.category_outlined, "Category", project.projectCategory ?? "N/A"),
                        _infoBlock(Icons.location_on_outlined, "Location", project.location ?? "N/A"),
                        _infoBlock(Icons.layers_outlined, "Soil Type", project.soilType ?? "N/A"),
                        _infoBlock(Icons.foundation_rounded, "Foundation", project.foundationType ?? "N/A"),
                        if (project.length != null)
                          _infoBlock(Icons.straighten_rounded, "Size", "${project.length}m × ${project.width}m"),
                        _infoBlock(Icons.calendar_today_rounded, "Date Created", project.createdAt.toLocal().toString().split(" ")[0]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_tree_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                _statusBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: accentBlue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        (project.projectStatus ?? "ACTIVE").toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _infoBlock(IconData icon, String label, String value) {
    return SizedBox(
      width: 160, // Desktop par boxes uniform dikhne ke liye
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: accentBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(color: primaryBlue.withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w800),
                ),
                Text(
                  value,
                  style: const TextStyle(color: primaryBlue, fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}