import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

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
          _header(),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.imageUrl.value.isEmpty) {
                return const Center(child: Text("No Drawing Found"));
              }

              return _viewer();
            }),
          ),

          _toolbar(),
        ],
      ),
    );
  }

  /// HEADER

  Widget _header() {
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
              'ZOOM ${(controller.currentZoom.value * 100).round()}%',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// VIEWER

  Widget _viewer() {
    final url = controller.imageUrl.value;

    return Container(
      margin: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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

          child: url.startsWith("data:image")
              ? Image.memory(
                  base64Decode(url.split(',').last),
                  fit: BoxFit.contain,
                )
              : Image.network(url, fit: BoxFit.contain),
        ),
      ),
    );
  }

  /// TOOLBAR

  Widget _toolbar() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          _btn(Icons.zoom_out_map, "Reset", controller.resetZoom),

          _btn(Icons.download, "Save", _save),

          _btn(Icons.share, "Share", _share),

          _btn(Icons.print, "Print", _print),

          _btn(Icons.delete_outline, "Clear", controller.clearDrawing),
        ],
      ),
    );
  }

  /// BUTTON

  Widget _btn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: primaryBlue),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// SAVE

  Future<void> _save() async {
    final bytes = await controller.getImageBytes();

    if (kIsWeb) {
      final blob = html.Blob([bytes]);

      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute("download", "drawing.png")
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      Get.snackbar("Saved", "Image downloaded");
    }
  }

  /// SHARE

  Future<void> _share() async {
    final bytes = await controller.getImageBytes();

    if (kIsWeb) {
      final blob = html.Blob([bytes]);

      final url = html.Url.createObjectUrlFromBlob(blob);

      html.window.open(url, "_blank");
    } else {
      await Share.shareXFiles([XFile.fromData(bytes, name: "drawing.png")]);
    }
  }

  /// PRINT

  Future<void> _print() async {
    final bytes = await controller.getImageBytes();

    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }
}
