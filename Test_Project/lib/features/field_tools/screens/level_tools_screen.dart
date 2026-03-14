import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  static const Color bgColor = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();

    /// START SENSOR
    controller.startLevelSensor();
  }

  @override
  void dispose() {
    /// STOP SENSOR
    controller.stopLevelSensor();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text("Digital Level Tool")),

      body: Obx(() {
        double x = controller.levelX.value;
        double y = controller.levelY.value;

        double xPos = (x / 10).clamp(-1.0, 1.0);
        double yPos = (y / 10).clamp(-1.0, 1.0);

        bool aligned = x.abs() < 0.5 && y.abs() < 0.5;

        return Column(
          children: [
            /// STATUS
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                aligned ? "SURFACE LEVEL" : "ADJUST POSITION",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: aligned ? Colors.green : accentBlue,
                ),
              ),
            ),

            /// LEVEL VIEW
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
                        border: Border.all(color: Colors.grey.shade300),
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
                      Container(width: 260, height: 3, color: Colors.red),

                    AnimatedAlign(
                      duration: const Duration(milliseconds: 100),
                      alignment: Alignment(xPos, yPos),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: aligned ? Colors.green : accentBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// DIGITAL VALUES
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _valueTile("X", controller.levelX.value),
                  _valueTile("Y", controller.levelY.value),
                ],
              ),
            ),

            /// CONTROLS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.resetCalibration,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text("Reset"),
                  ),

                  ElevatedButton.icon(
                    onPressed: controller.toggleLaser,
                    icon: const Icon(Icons.horizontal_rule),
                    label: const Text("Laser"),
                  ),

                  ElevatedButton.icon(
                    onPressed: controller.holdMeasurement,
                    icon: const Icon(Icons.pause),
                    label: const Text("Hold"),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _valueTile(String label, double value) {
    return Column(
      children: [
        Text(label),
        Text(
          "${value.toStringAsFixed(2)}°",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
