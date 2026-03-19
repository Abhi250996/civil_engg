import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/route_constants.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthController authController = Get.find();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  final List<Map<String, dynamic>> _navItems = [
    {
      'title': 'PROJECTS',
      'icon': Icons.inventory_2_outlined,
      'route': RouteConstants.projects,
    },
    {
      'title': 'CALCS',
      'icon': Icons.analytics_outlined,
      'route': RouteConstants.calculationType,
    },
    {
      'title': 'TOOLS',
      'icon': Icons.handyman_outlined,
      'route': RouteConstants.fieldTools,
    },
    {
      'title': 'AI CHAT',
      'icon': Icons.psychology_outlined,
      'route': RouteConstants.aiChat,
    },
    {
      'title': 'REPORTS',
      'icon': Icons.assignment_outlined,
      'route': RouteConstants.reports,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      body: Container(
        /// 🔥 GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "FIELDOPS PRO",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      IconButton(
                        onPressed: authController.logout,
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ================= MAIN CARD =================
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// GRID
                          Expanded(
                            child: GridView.builder(
                              itemCount: _navItems.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isDesktop ? 5 : 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (_, i) => _navCard(_navItems[i]),
                            ),
                          ),

                          /// FOOTER
                          Center(
                            child: Text(
                              "Select a module to continue",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= NAV CARD =================
  Widget _navCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => Get.toNamed(item['route']),
      borderRadius: BorderRadius.circular(12),

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icon'], color: accentBlue, size: 26),
            const SizedBox(height: 10),
            Text(
              item['title'],
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
