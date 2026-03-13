import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/project_model.dart';
import '../controllers/calculation_controller.dart';

class CalculationTypeScreen extends StatelessWidget {
  const CalculationTypeScreen({super.key});

  int getColumns(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final ProjectModel? project = Get.arguments;

    final controller = Get.put(CalculationController());

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Select Structure Type")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.builder(
          itemCount: controller.structureTypes.length,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getColumns(width),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),

          itemBuilder: (context, index) {
            final item = controller.structureTypes[index];

            return _typeCard(
              title: item["title"],
              icon: item["icon"],
              onTap: () {
                controller.openStructure(project, item["type"]);
              },
            );
          },
        ),
      ),
    );
  }

  /// =========================
  /// TYPE CARD
  /// =========================

  Widget _typeCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.blue.shade50,

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
