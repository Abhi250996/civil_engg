import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/calculation_controller.dart';
import '../widgets/drawing_canvas_widget.dart';

class DrawingResultScreen extends StatefulWidget {
  const DrawingResultScreen({super.key});

  @override
  State<DrawingResultScreen> createState() => _DrawingResultScreenState();
}

class _DrawingResultScreenState extends State<DrawingResultScreen> {
  final CalculationController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drawing Result")),

      body: Column(
        children: [
          /// =========================
          /// DRAWING AREA
          /// =========================
          Expanded(
            child: Container(
              color: Colors.grey.shade300,

              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DrawingCanvasWidget(
                  objects: controller.objects.toList(),
                );
              }),
            ),
          ),

          /// =========================
          /// CONTROL PANEL
          /// =========================
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.1)),
              ],
            ),

            child: Row(
              children: [
                /// EXPORT BUTTON
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Export Drawing"),
                  onPressed: controller.exportDrawing,
                ),

                const SizedBox(width: 12),

                /// GENERATE TEST
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Generate AI Drawing"),
                  onPressed: () {
                    controller.generateAIDrawing(
                      "Generate industrial plant layout with tanks, pump and pipes with dimensions",
                    );
                  },
                ),

                const Spacer(),

                /// BACK BUTTON
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                  onPressed: Get.back,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
