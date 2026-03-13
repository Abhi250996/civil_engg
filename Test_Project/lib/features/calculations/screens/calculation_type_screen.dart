import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../controllers/calculation_controller.dart';

class CalculationTypeScreen extends StatefulWidget {
  const CalculationTypeScreen({super.key});

  @override
  State<CalculationTypeScreen> createState() => _CalculationTypeScreenState();
}

class _CalculationTypeScreenState extends State<CalculationTypeScreen>
    with TickerProviderStateMixin {
  late final CalculationController controller;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  static const primaryBlue = Color(0xFF1E3A8A);
  static const bgColor = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    controller = Get.put(CalculationController());
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProjectModel? project = Get.arguments;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40, // Reduced height
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryBlue, size: 16),
          onPressed: () => Get.back(),
        ),
        title: const Text('MODULES',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive column logic for small squares
          double width = constraints.maxWidth;
          int crossAxisCount = (width > 1000) ? 8 : (width > 700) ? 6 : (width > 400) ? 4 : 3;

          return FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: const Text('Select Module',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: primaryBlue)),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.structureTypes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.0, // Forced Square
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.structureTypes[index];
                      return _SmallSquareCard(
                        title: item['title'] as String,
                        icon: item['icon'] as IconData,
                        onTap: () => controller.openStructure(project, item['type']),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SmallSquareCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SmallSquareCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: const Color(0xFF1E3A8A)),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 8,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}