import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculation_controller.dart';

class DrawingResultScreen extends GetView<CalculationController> {
  const DrawingResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors from your context
    const primaryBlue = Color(0xFF1E3A8A);
    const accentBlue = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Structural Blueprint', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: primaryBlue),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Info Header - Using Obx only where data changes
          _buildZoomHeader(primaryBlue, accentBlue),

          // Main Viewer Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return _buildLoading(primaryBlue);
              if (controller.imageUrl.value.isEmpty) return _buildEmpty(primaryBlue);

              return _buildImageCanvas(primaryBlue);
            }),
          ),

          // Tools Bar
          _buildToolBar(primaryBlue),
        ],
      ),
    );
  }

  Widget _buildZoomHeader(Color primary, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: primary.withOpacity(0.05),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, size: 16, color: accent),
          const SizedBox(width: 8),
          const Text('AI-OPTIMIZED GENERATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A))),
          const Spacer(),
          Obx(() => Text(
            'ZOOM: ${(controller.currentZoom.value * 100).round()}%',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primary),
          )),
        ],
      ),
    );
  }

  Widget _buildImageCanvas(Color primaryBlue) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InteractiveViewer(
          transformationController: controller.transController,
          maxScale: 5.0,
          onInteractionUpdate: (details) {
            // UI se logic nikal kar controller mein daal di
            controller.updateZoom(controller.transController.value.getMaxScaleOnAxis());
          },
          child: Image.network(
            controller.imageUrl.value,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildToolBar(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE5E7EB)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _toolButton(Icons.zoom_out_map_rounded, "Reset", () => controller.resetZoom(), primary),
          _toolButton(Icons.download_rounded, "Save", () {}, primary),
          _toolButton(Icons.print_outlined, "Print", () {}, primary),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, String label, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Loading and Empty states remain similar but simplified...
  Widget _buildLoading(Color color) => Center(child: CircularProgressIndicator(color: color));
  Widget _buildEmpty(Color color) => const Center(child: Text("No Drawing Found"));
}