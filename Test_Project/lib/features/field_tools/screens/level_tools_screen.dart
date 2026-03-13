import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_tools_controller.dart';

class LevelToolScreen extends StatelessWidget {
  const LevelToolScreen({super.key});

  // Theme Tokens
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC);     // Soft White

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FieldToolsController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryBlue, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "DIGITAL SPIRIT LEVEL",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
        ),
      ),
      body: Obx(() {
        // Normalizing values for visual bubble movement
        // Assuming sensor range is roughly -10 to 10 for mapping
        double xPos = (controller.levelX.value / 10).clamp(-1.0, 1.0);
        double yPos = (controller.levelY.value / 10).clamp(-1.0, 1.0);

        bool isPerfect = controller.levelX.value.abs() < 0.5 && controller.levelY.value.abs() < 0.5;

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    isPerfect ? "LEVEL ALIGNED" : "ADJUST SURFACE",
                    style: TextStyle(
                      color: isPerfect ? Colors.green : accentBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Place device flat on the surface for accuracy",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Visual Bubble Level ---
                    _buildVisualLevel(xPos, yPos, isPerfect),

                    const SizedBox(height: 60),

                    // --- Digital Readouts ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _readoutTile("X-AXIS TILT", "${controller.levelX.value.toStringAsFixed(1)}°"),
                          _readoutTile("Y-AXIS TILT", "${controller.levelY.value.toStringAsFixed(1)}°"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildCalibrationButton(),
          ],
        );
      }),
    );
  }

  Widget _buildVisualLevel(double x, double y, bool isPerfect) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: isPerfect ? Colors.green : const Color(0xFFE5E7EB), width: 2),
        boxShadow: [
          BoxShadow(color: primaryBlue.withOpacity(0.05), blurRadius: 30, spreadRadius: 10),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Target Rings
          _circleIndicator(60),
          _circleIndicator(120),

          // Axis Lines
          Container(width: 1, height: 240, color: const Color(0xFFE5E7EB)),
          Container(width: 240, height: 1, color: const Color(0xFFE5E7EB)),

          // The Floating Bubble
          AnimatedAlign(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment(x, y),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isPerfect
                      ? [Colors.green.shade300, Colors.green.shade700]
                      : [accentBlue, accentBlue],
                ),
                boxShadow: [
                  BoxShadow(
                      color: (isPerfect ? Colors.green : accentBlue).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(2, 4)
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIndicator(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
    );
  }

  Widget _readoutTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 28, color: primaryBlue, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildCalibrationButton() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: OutlinedButton.icon(
        onPressed: () {}, // Logic for zero-setting if needed
        icon: const Icon(Icons.restart_alt_rounded, size: 18),
        label: const Text("RESET CALIBRATION"),
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}