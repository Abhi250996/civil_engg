import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/field_tools_controller.dart';
import '../widgets/tool_card.dart';

class FieldToolsScreen extends StatelessWidget {
  const FieldToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FieldToolsController controller = Get.find();

    final width = MediaQuery.of(context).size.width;

    /// Responsive grid
    int crossAxisCount = 2;

    if (width > 1200) {
      crossAxisCount = 4;
    } else if (width > 800) {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Field Tools"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,

          children: [
            /// DISTANCE MEASUREMENT
            ToolCard(
              title: "Measure Distance",
              icon: Icons.straighten,
              color: Colors.blue,
              onTap: controller.openMeasurement,
            ),

            /// LEVEL TOOL
            ToolCard(
              title: "Level Tool",
              icon: Icons.architecture,
              color: Colors.orange,
              onTap: controller.openLevelTool,
            ),

            /// GPS MAPPING
            ToolCard(
              title: "GPS Mapping",
              icon: Icons.map,
              color: Colors.green,
              onTap: controller.openGpsTool,
            ),

            /// SITE PHOTOS
            ToolCard(
              title: "Site Photos",
              icon: Icons.camera_alt,
              color: Colors.purple,
              onTap: controller.openCamera,
            ),

            /// FUTURE TOOL (Area Measurement)
            ToolCard(
              title: "Area Measure",
              icon: Icons.square_foot,
              color: Colors.teal,
              onTap: () {
                Get.snackbar("Area Measurement", "Feature coming soon");
              },
            ),

            /// FUTURE TOOL (Slope)
            ToolCard(
              title: "Slope Calculator",
              icon: Icons.show_chart,
              color: Colors.red,
              onTap: () {
                Get.snackbar("Slope Calculator", "Feature coming soon");
              },
            ),
          ],
        ),
      ),
    );
  }
}
