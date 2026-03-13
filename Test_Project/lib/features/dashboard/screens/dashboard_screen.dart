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

  // Saved Brand Colors
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color bgColor = Color(0xFFF8FAFC);     // Soft White

  final List<Map<String, dynamic>> _navItems = [
    {'title': 'PROJECTS', 'icon': Icons.inventory_2_outlined, 'route': RouteConstants.projects},
    {'title': 'CALCS', 'icon': Icons.analytics_outlined, 'route': RouteConstants.calculationType},
    {'title': 'TOOLS', 'icon': Icons.handyman_outlined, 'route': RouteConstants.fieldTools},
    {'title': 'AI CHAT', 'icon': Icons.psychology_outlined, 'route': RouteConstants.aiChat},
    {'title': 'REPORTS', 'icon': Icons.assignment_outlined, 'route': RouteConstants.reports},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text('FIELDOPS PRO', style: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded,color:  Colors.white,size: 18), onPressed: () => authController.logout()),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// COMPACT HORIZONTAL NAV BAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _navItems.map((item) => _buildSquareNavCard(item)).toList(),
              ),
            ),
          ),

          /// MAIN CONTENT AREA (Placeholder)
          Expanded(
            child: Center(
              child: Text(
                "Select a module from the toolbar above",
                style: TextStyle(color: primaryBlue.withOpacity(0.3), fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareNavCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => Get.toNamed(item['route']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 85,  // Square Width
          height: 85, // Square Height
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center Icon and Text
            children: [
              Icon(item['icon'], color: accentBlue, size: 24),
              const SizedBox(height: 8),
              Text(
                item['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 9, // Smaller font for square look
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}