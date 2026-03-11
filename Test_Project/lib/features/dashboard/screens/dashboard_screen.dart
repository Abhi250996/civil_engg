import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,

          children: [
            _dashboardCard(
              title: "Projects",
              icon: Icons.folder,
              onTap: () {
                Get.toNamed(RouteConstants.projects);
              },
            ),

            _dashboardCard(
              title: "Calculations",
              icon: Icons.calculate,
              onTap: () {
                Get.toNamed(RouteConstants.calculationType);
              },
            ),

            _dashboardCard(
              title: "Field Tools",
              icon: Icons.construction,
              onTap: () {
                Get.toNamed(RouteConstants.fieldTools);
              },
            ),

            _dashboardCard(
              title: "AI Assistant",
              icon: Icons.smart_toy,
              onTap: () {
                Get.toNamed(RouteConstants.aiChat);
              },
            ),

            _dashboardCard(
              title: "Reports",
              icon: Icons.description,
              onTap: () {
                Get.toNamed(RouteConstants.reports);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// DASHBOARD CARD
  /// =========================

  Widget _dashboardCard({
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
