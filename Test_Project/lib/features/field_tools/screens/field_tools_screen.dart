import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/field_tools_controller.dart';
import '../widgets/tool_card.dart';

class FieldToolsScreen extends StatelessWidget {
  const FieldToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FieldToolsController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text("Field Tools")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,

          children: [
            /// DISTANCE MEASUREMENT
            ToolCard(
              title: "Measure Distance",
              icon: Icons.straighten,
              onTap: controller.openMeasurement,
            ),

            /// LEVEL TOOL
            ToolCard(
              title: "Level Tool",
              icon: Icons.architecture,
              onTap: controller.openLevelTool,
            ),

            /// GPS MAPPING
            ToolCard(
              title: "GPS Mapping",
              icon: Icons.map,
              onTap: controller.openGpsTool,
            ),

            /// PHOTO CAPTURE
            ToolCard(
              title: "Site Photos",
              icon: Icons.camera_alt,
              onTap: controller.openCamera,
            ),
          ],
        ),
      ),
    );
  }
}
