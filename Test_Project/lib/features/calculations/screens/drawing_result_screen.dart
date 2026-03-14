import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import '../controllers/calculation_controller.dart';

class DrawingResultScreen extends GetView<CalculationController> {
  const DrawingResultScreen({super.key});

  static const primaryBlue = Color(0xFF1E3A8A);
  static const accentBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Structural Blueprint',
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: primaryBlue),
          onPressed: () {
            controller.clearDrawing();
            Get.back();
          },
        ),
      ),

      body: Column(
        children: [
          _buildZoomHeader(),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.imageUrl.value.isEmpty) {
                return const Center(child: Text("No Drawing Found"));
              }

              return _buildImageCanvas();
            }),
          ),

          _buildToolBar(),
        ],
      ),
    );
  }

  /// HEADER

  Widget _buildZoomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: primaryBlue.withOpacity(0.05),

      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 16, color: accentBlue),

          const SizedBox(width: 8),

          const Text(
            'AI GENERATED DRAWING',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: primaryBlue,
            ),
          ),

          const Spacer(),

          Obx(
            () => Text(
              'ZOOM: ${(controller.currentZoom.value * 100).round()}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE VIEWER

  Widget _buildImageCanvas() {
    return Container(
      margin: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),

        child: InteractiveViewer(
          transformationController: controller.transController,
          maxScale: 6,
          minScale: 0.5,

          onInteractionUpdate: (_) {
            controller.updateZoom(
              controller.transController.value.getMaxScaleOnAxis(),
            );
          },

          child: Image.network(controller.imageUrl.value, fit: BoxFit.contain),
        ),
      ),
    );
  }

  /// TOOLBAR

  Widget _buildToolBar() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _toolButton(Icons.zoom_out_map, "Reset Zoom", controller.resetZoom),

          _toolButton(Icons.download, "Save", () {
            _saveDrawing();
          }),

          _toolButton(Icons.share, "Share", () {
            _shareDrawing();
          }),

          _toolButton(Icons.print, "Print", () {
            _printDrawing();
          }),

          _toolButton(Icons.delete_outline, "Clear", () {
            controller.clearDrawing();
          }),
        ],
      ),
    );
  }

  /// BUTTON

  Widget _toolButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: primaryBlue, size: 26),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  /// SAVE DRAWING

  Future<void> _saveDrawing() async {
    final url = controller.imageUrl.value;

    final response = await http.get(Uri.parse(url));

    await ImageGallerySaver.saveImage(response.bodyBytes);

    Get.snackbar("Saved", "Drawing saved to gallery");
  }

  /// SHARE DRAWING

  Future<void> _shareDrawing() async {
    final url = controller.imageUrl.value;

    final response = await http.get(Uri.parse(url));

    final tempDir = Directory.systemTemp;

    final file = File("${tempDir.path}/drawing.png");

    await file.writeAsBytes(response.bodyBytes);

    await Share.shareXFiles([XFile(file.path)]);
  }

  /// PRINT DRAWING

  Future<void> _printDrawing() async {
    final url = controller.imageUrl.value;

    final response = await http.get(Uri.parse(url));

    await Printing.layoutPdf(onLayout: (_) async => response.bodyBytes);
  }
}
