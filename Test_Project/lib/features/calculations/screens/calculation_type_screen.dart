import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../data/models/project_model.dart';

class CalculationTypeScreen extends StatelessWidget {
  const CalculationTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectModel? project = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("Select Structure Type")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,

          children: [
            /// =========================
            /// BUILDING / HOUSE
            /// =========================
            _typeCard(
              title: "Building / House",
              icon: Icons.home_work,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "building"},
                );
              },
            ),

            /// =========================
            /// INDUSTRIAL PLANT
            /// =========================
            _typeCard(
              title: "Industrial Plant",
              icon: Icons.factory,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "plant"},
                );
              },
            ),

            /// =========================
            /// FACTORY LAYOUT
            /// =========================
            _typeCard(
              title: "Factory Layout",
              icon: Icons.precision_manufacturing,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "factory"},
                );
              },
            ),

            /// =========================
            /// ROAD DESIGN
            /// =========================
            _typeCard(
              title: "Road Layout",
              icon: Icons.alt_route,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "road"},
                );
              },
            ),

            /// =========================
            /// CHIMNEY STRUCTURE
            /// =========================
            _typeCard(
              title: "Chimney",
              icon: Icons.vertical_align_top,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "chimney"},
                );
              },
            ),

            /// =========================
            /// FOUNDATION DESIGN
            /// =========================
            _typeCard(
              title: "Foundation",
              icon: Icons.foundation,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "foundation"},
                );
              },
            ),

            /// =========================
            /// WATER TANK
            /// =========================
            _typeCard(
              title: "Water Tank",
              icon: Icons.water,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "tank"},
                );
              },
            ),

            /// =========================
            /// CUSTOM ENGINEERING
            /// =========================
            _typeCard(
              title: "Custom Structure",
              icon: Icons.architecture,
              onTap: () {
                Get.toNamed(
                  RouteConstants.houseInput,
                  arguments: {"project": project, "type": "custom"},
                );
              },
            ),
          ],
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
    return GestureDetector(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue.shade50,
        ),

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
