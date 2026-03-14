import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_tools_controller.dart';
import '../widgets/tool_card.dart';

class FieldToolsScreen extends StatelessWidget {
  const FieldToolsScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color bgColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    final FieldToolsController controller = Get.find();
    final double width = MediaQuery.of(context).size.width;

    final bool isDesktop = width > 900;
    final bool isTablet = width > 600 && width <= 900;

    final tools = [
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
        title: "Photos",
        subtitle: "Site Media",
        icon: Icons.camera_enhance_rounded,
        onTap: controller.openCamera,
      ),
      ToolCard(
        title: "Area",
        subtitle: "Plot Size",
        icon: Icons.square_foot_rounded,
        isLocked: true,
        onTap: () {},
      ),
      ToolCard(
        title: "Slope",
        subtitle: "Gradient",
        icon: Icons.show_chart_rounded,
        isLocked: true,
        onTap: () {},
      ),
    ];

    int crossAxisCount = 2;

    if (isTablet) {
      crossAxisCount = 3;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "FIELD TOOLS",
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 30),

            /// Desktop → Horizontal Toolbar
            if (isDesktop)
              SizedBox(
                height: 90,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tools
                        .map(
                          (tool) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: tool,
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            /// Mobile + Tablet → Grid
            else
              Expanded(
                child: GridView.builder(
                  itemCount: tools.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return tools[index];
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Select Utility",
          style: TextStyle(
            color: primaryBlue,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Digital instruments for civil engineering tasks",
          textAlign: TextAlign.center,
          style: TextStyle(color: primaryBlue.withOpacity(0.5), fontSize: 14),
        ),
      ],
    );
  }
}
