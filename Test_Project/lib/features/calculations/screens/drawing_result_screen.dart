import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/calculation_controller.dart';

class DrawingResultScreen extends StatelessWidget {
  const DrawingResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculationController>();

    return Scaffold(
      appBar: AppBar(title: const Text("AI Generated Drawing")),

      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          if (controller.imageUrl.value.isEmpty) {
            return const Text("No drawing generated");
          }

          return InteractiveViewer(
            maxScale: 5,

            child: Image.network(
              controller.imageUrl.value,
              fit: BoxFit.contain,
            ),
          );
        }),
      ),
    );
  }
}
