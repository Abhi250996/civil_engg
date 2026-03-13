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
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    String formattedDate = project.startDate != null
        ? DateFormat('dd-MM-yyyy').format(project.startDate!)
        : "No Date Set";

    return Container(
      // Render Error fix: Iski height wahi hogi jo GridView ne di hai
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Yeh content ko overflow hone se bachayega
              children: [
                /// HEADER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.engineering_rounded, size: 18, color: accentBlue),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryBlue),
                          ),
                          Text(
                            project.projectCategory ?? "Project",
                            style: TextStyle(fontSize: 10, color: primaryBlue.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, thickness: 0.5),
                ),

                /// INFO SECTION - Removed Flexible and used simple Column
                /// Taaki RenderFlex overflow na ho
                _infoRow(Icons.location_on_outlined, project.location ?? "No Location"),
                const SizedBox(height: 5),
                _infoRow(Icons.calendar_month_outlined, formattedDate),
                const SizedBox(height: 5),
                _infoRow(Icons.straighten_rounded,
                    (project.length != null && project.width != null)
                        ? "${project.length}m × ${project.width}m"
                        : "No Dimensions"),

                const Spacer(), // Yeh footer ko bottom mein dhakelega

                /// FOOTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (project.projectStatus ?? "ACTIVE").toUpperCase(),
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: primaryBlue),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 12, color: primaryBlue.withOpacity(0.4)),
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