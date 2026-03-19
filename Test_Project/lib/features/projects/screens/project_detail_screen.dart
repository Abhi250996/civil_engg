import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final ProjectModel project = Get.arguments;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      body: Container(
        /// 🔥 GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// ================= HEADER =================
                  Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Expanded(
                        child: Text(
                          project.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ================= MAIN CARD =================
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _header(project),

                            const SizedBox(height: 20),

                            /// GRID
                            GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: isDesktop ? 350 : 500,
                                    mainAxisExtent: 220,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              children: [
                                _card("Basic Info", [
                                  _row(
                                    "Category",
                                    project.projectCategory ?? "-",
                                  ),
                                  _row("Location", project.location ?? "-"),
                                  _row("Budget", "₹ ${project.budget ?? "-"}"),
                                ]),

                                _card("Engineering", [
                                  _row("Soil", project.soilType ?? "-"),
                                  _row(
                                    "Foundation",
                                    project.foundationType ?? "-",
                                  ),
                                  _row(
                                    "Structure",
                                    project.structureType ?? "-",
                                  ),
                                ]),

                                _card("Timeline", [
                                  _row(
                                    "Start",
                                    project.startDate?.toString().split(
                                          " ",
                                        )[0] ??
                                        "-",
                                  ),
                                  _row(
                                    "Target",
                                    project.completionDate?.toString().split(
                                          " ",
                                        )[0] ??
                                        "-",
                                  ),
                                ]),

                                _actionCard(project),
                              ],
                            ),

                            const SizedBox(height: 20),

                            _notes(project.description),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _header(ProjectModel p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.projectStatus ?? "ACTIVE",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            p.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget _card(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// ================= NOTES =================
  Widget _notes(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        text.isEmpty ? "No notes available" : text,
        style: const TextStyle(height: 1.4),
      ),
    );
  }

  /// ================= ACTION =================
  Widget _actionCard(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _btn("Calculations", () {
            Get.toNamed(RouteConstants.calculationType, arguments: project);
          }),
          const SizedBox(height: 10),
          _btn("Field Tools", () {
            Get.toNamed(RouteConstants.fieldTools, arguments: project);
          }),
          const SizedBox(height: 10),
          _btn("Reports", () {
            Get.toNamed(RouteConstants.reports, arguments: project);
          }),
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: accentBlue),
        child: Text(text),
      ),
    );
  }
}
