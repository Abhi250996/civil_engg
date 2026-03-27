import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';
import '../controllers/field_tools_controller.dart';
import '../widgets/tool_card.dart';

class FieldToolsScreen extends StatelessWidget {
  const FieldToolsScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FieldToolsController>();

    return AppScaffold(
      title: "Field Tools",
      showBack: true,
      child: Container(
        /// 🔥 GRADIENT BACKGROUND
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
            child: SizedBox(
              width: double.infinity,

              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    int crossAxisCount = 2;
                    if (width > 600) crossAxisCount = 3;
                    if (width > 900) crossAxisCount = 4;
                    if (width > 1200) crossAxisCount = 6;

                    final tools = _buildTools(controller);

                    return Column(
                      children: [
                        /// HEADER (INSIDE CARD)
                        const SizedBox(height: 8),

                        Text(
                          "Digital instruments for civil engineering tasks",
                          style: TextStyle(color: primaryBlue.withOpacity(0.5)),
                        ),

                        const SizedBox(height: 24),

                        /// GRID (ALL DEVICES)
                        Expanded(
                          child: GridView.builder(
                            itemCount: tools.length,

                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1,
                                ),

                            itemBuilder: (context, index) {
                              return tools[index];
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= TOOLS =================
  List<Widget> _buildTools(FieldToolsController controller) {
    return [
      ToolCard(
        title: "Measure",
        subtitle: "Distance",
        icon: Icons.straighten_rounded,
        onTap: controller.openMeasurement,
      ),
      ToolCard(
        title: "Level",
        subtitle: "Spirit Tool",
        icon: Icons.architecture_rounded,
        onTap: controller.openLevelTool,
      ),
      ToolCard(
        title: "GPS",
        subtitle: "Mapping",
        icon: Icons.map_rounded,
        onTap: controller.openGpsTool,
      ),
      ToolCard(
        title: "Area",
        subtitle: "Plot Size",
        icon: Icons.square_foot_rounded,
        onTap: controller.openAreaTool,
      ),
      ToolCard(
        title: "Slope",
        subtitle: "Gradient",
        icon: Icons.show_chart_rounded,
        onTap: controller.openSlopeTool,
      ),
      ToolCard(
        title: "Converter",
        subtitle: "Unit Scaling",
        icon: Icons.sync_alt_rounded,
        onTap: controller.openUnitConverter,
      ),
      ToolCard(
        title: "Concrete",
        subtitle: "Volume Calc",
        icon: Icons.layers_rounded,
        onTap: controller.openConcreteCalc,
      ),
      ToolCard(
        title: "Steel",
        subtitle: "Weight Calc",
        icon: Icons.reorder_rounded,
        onTap: controller.openSteelCalc,
      ),
      ToolCard(
        title: "Photos",
        subtitle: "Site Media",
        icon: Icons.camera_enhance_rounded,
        onTap: controller.openCamera,
      ),
      ToolCard(
        title: "Site Diary",
        subtitle: "Daily Log",
        icon: Icons.edit_note_rounded,
        onTap: controller.openSiteDiary,
      ),
      ToolCard(
        title: "CAD View",
        subtitle: "DWG/DXF",
        icon: Icons.view_in_ar_rounded,
        onTap: controller.openCadViewer,
      ),
      ToolCard(
        title: "Sun Path",
        subtitle: "Orientation",
        icon: Icons.wb_sunny_rounded,
        onTap: controller.openSunSeeker,
      ),
    ];
  }
}
