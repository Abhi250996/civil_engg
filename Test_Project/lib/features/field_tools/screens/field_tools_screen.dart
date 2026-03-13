import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_tools_controller.dart';
import '../widgets/tool_card.dart';

class FieldToolsScreen extends StatelessWidget {
  const FieldToolsScreen({super.key});

  // Theme Tokens
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color bgColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    final FieldToolsController controller = Get.find();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "FIELD TOOLS",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center, // Desktop par content center mein rahega
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000), // Max width for Desktop
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit to content
              children: [
                _buildHeader(),
                const SizedBox(height: 32),

                // Flexible use kiya hai taaki grid window ke andar hi rahe
                Flexible(
                  child: GridView(
                    shrinkWrap: true,
                    // Desktop par cards chote dikhane ke liye crossAxisCount badha diya
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180, // Card ki max width 180px hogi
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9, // Card ko thoda vertical shape diya professional look ke liye
                    ),
                    // Scroll band karne ke liye
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Select Utility",
          style: TextStyle(color: primaryBlue, fontSize: 28, fontWeight: FontWeight.bold),
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