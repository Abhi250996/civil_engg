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

    /// ✅ FIX: prevent multiple instances
    controller = Get.isRegistered<CalculationController>()
        ? Get.find<CalculationController>()
        : Get.put(CalculationController());

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

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
        toolbarHeight: 42,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryBlue,
            size: 16,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'MODULES',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
      ),

      /// ================= BODY =================
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;

              int crossAxisCount = (width > 1200)
                  ? 8
                  : (width > 900)
                  ? 6
                  : (width > 600)
                  ? 5
                  : (width > 400)
                  ? 4
                  : 3;

              return FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.white,
                      child: const Text(
                        'Select Module',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: primaryBlue,
                        ),
                      ),
                    ),

                    /// ================= GRID =================
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: controller.structureTypes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final item = controller.structureTypes[index];

                          return _SmallSquareCard(
                            title: item['title'] as String,
                            icon: item['icon'] as IconData,
                            onTap: () {
                              controller.openStructure(project, item['type']);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          /// ================= GLOBAL LOADER =================
          Obx(() {
            if (!controller.isLoading.value) return const SizedBox();

            return Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            );
          }),
        ],
      ),
    );
  }
}

class _SmallSquareCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SmallSquareCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SmallSquareCard> createState() => _SmallSquareCardState();
}

class _SmallSquareCardState extends State<_SmallSquareCard> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTapCancel: () => setState(() => scale = 1.0),

      onTap: widget.onTap,

      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),

        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          elevation: 1,

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 0.8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 24, color: const Color(0xFF1E3A8A)),

                const SizedBox(height: 6),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 9,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
