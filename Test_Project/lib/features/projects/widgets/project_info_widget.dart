import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';

class ProjectInfoWidget extends StatelessWidget {
  final ProjectModel project;

  const ProjectInfoWidget({super.key, required this.project});

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            /// 🔥 GLASS CARD
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HEADER =================
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_tree_rounded,
                      color: accentBlue,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _statusBadge(),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ================= OVERVIEW =================
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
                ),
              ),

              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 20),

              /// ================= DETAILS =================
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _infoBlock(
                    Icons.category_outlined,
                    "Category",
                    project.projectCategory ?? "N/A",
                  ),

                  _infoBlock(
                    Icons.location_on_outlined,
                    "Location",
                    project.location ?? "N/A",
                  ),

                  _infoBlock(
                    Icons.layers_outlined,
                    "Soil",
                    project.soilType ?? "N/A",
                  ),

                  _infoBlock(
                    Icons.foundation_rounded,
                    "Foundation",
                    project.foundationType ?? "N/A",
                  ),

                  if (project.length != null)
                    _infoBlock(
                      Icons.straighten_rounded,
                      "Size",
                      "${project.length}m × ${project.width}m",
                    ),

                  _infoBlock(
                    Icons.calendar_today_rounded,
                    "Created",
                    project.createdAt.toLocal().toString().split(" ")[0],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= SMALL COMPONENTS =================

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        (project.projectStatus ?? "ACTIVE").toUpperCase(),
        style: const TextStyle(
          color: primaryBlue,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoBlock(IconData icon, String label, String value) {
    return SizedBox(
      width: 180,
      child: Row(
        children: [
          Icon(icon, size: 18, color: accentBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    color: primaryBlue.withOpacity(0.4),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
