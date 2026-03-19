import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    String formattedDate = project.startDate != null
        ? DateFormat('dd-MM-yyyy').format(project.startDate!)
        : "No Date";

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          /// 🔥 GLASS EFFECT
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),

          /// SHADOW
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.engineering_rounded,
                    size: 18,
                    color: accentBlue,
                  ),
                ),

                const SizedBox(width: 10),

                /// TITLE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      Text(
                        project.projectCategory ?? "Project",
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryBlue.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                /// DELETE
                InkWell(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Divider(height: 1),

            const SizedBox(height: 10),

            /// ================= INFO =================
            _infoRow(
              Icons.location_on_outlined,
              project.location ?? "No Location",
            ),

            const SizedBox(height: 6),

            _infoRow(Icons.calendar_month_outlined, formattedDate),

            const SizedBox(height: 6),

            _infoRow(
              Icons.straighten_rounded,
              (project.length != null && project.width != null)
                  ? "${project.length}m × ${project.width}m"
                  : "No Dimensions",
            ),

            const Spacer(),

            /// ================= FOOTER =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (project.projectStatus ?? "ACTIVE").toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: primaryBlue,
                    ),
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 13, color: primaryBlue.withOpacity(0.4)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: primaryBlue),
          ),
        ),
      ],
    );
  }
}
