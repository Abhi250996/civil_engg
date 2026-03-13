import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/field_tools_controller.dart';

class LevelToolScreen extends StatelessWidget {
  const LevelToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FieldToolsController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Level Tool")),

      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "X Tilt: ${controller.levelX.value.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 24),
              ),

              const SizedBox(height: 20),

              Text(
                "Y Tilt: ${controller.levelY.value.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 24),
              ),
            ],
          );
        }),
      ),
    );
  }
}
