import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';
import '../controllers/field_tools_controller.dart';

class LevelToolScreen extends StatefulWidget {
  const LevelToolScreen({super.key});

  @override
  State<LevelToolScreen> createState() => _LevelToolScreenState();
}

class _LevelToolScreenState extends State<LevelToolScreen> {
  final controller = Get.find<FieldToolsController>();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  @override
  void initState() {
    super.initState();
    controller.startLevelSensor();
  }

  @override
  void dispose() {
    controller.stopLevelSensor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Level Tool",
      showBack: true,
      child: Container(
        /// 🔥 GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Obx(() {
                double x = controller.levelX.value;
                double y = controller.levelY.value;

                double xPos = (x / 10).clamp(-1.0, 1.0);
                double yPos = (y / 10).clamp(-1.0, 1.0);

                bool aligned = x.abs() < 0.5 && y.abs() < 0.5;

                return Column(
                  children: [
                    /// HEADER
                    const Text(
                      "DIGITAL LEVEL TOOL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// MAIN CARD
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Column(
                          children: [
                            /// STATUS
                            Text(
                              aligned ? "SURFACE LEVEL" : "ADJUST POSITION",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: aligned ? Colors.green : accentBlue,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// LEVEL VISUAL
                            Expanded(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 260,
                                      height: 260,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: 260,
                                      height: 2,
                                      color: Colors.grey.shade300,
                                    ),

                                    Container(
                                      width: 2,
                                      height: 260,
                                      color: Colors.grey.shade300,
                                    ),

                                    if (controller.showLaser.value)
                                      Container(
                                        width: 260,
                                        height: 3,
                                        color: Colors.red,
                                      ),

                                    AnimatedAlign(
                                      duration: const Duration(
                                        milliseconds: 100,
                                      ),
                                      alignment: Alignment(xPos, yPos),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: aligned
                                              ? Colors.green
                                              : accentBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// VALUES
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _valueTile("X", x),
                                _valueTile("Y", y),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// BUTTONS
                            Wrap(
                              spacing: 12,
                              children: [
                                _btn(
                                  "Reset",
                                  Icons.restart_alt,
                                  controller.resetCalibration,
                                ),
                                _btn(
                                  "Laser",
                                  Icons.horizontal_rule,
                                  controller.toggleLaser,
                                ),
                                _btn(
                                  "Hold",
                                  Icons.pause,
                                  controller.holdMeasurement,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _valueTile(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          "${value.toStringAsFixed(2)}°",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _btn(String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: accentBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
