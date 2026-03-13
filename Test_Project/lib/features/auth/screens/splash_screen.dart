import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeIn),
    );

    _mainController.forward();
  }

  Future<void> _initializeApp() async {
    // Artificial delay for branding
    await Future.delayed(const Duration(seconds: 3));

    final token = StorageService.read("token");
    if (token != null) {
      Get.offAllNamed(RouteConstants.dashboard);
    } else {
      Get.offAllNamed(RouteConstants.login);
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const primaryBlue = Color(0xFF1E3A8A); // Deep Blue
    const bgColor = Color(0xFFF8FAFC);     // Soft White

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background subtle pattern or clean space
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo/Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.engineering_rounded, // Using Engineering icon as per context
                        size: 80,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // App Name
                    Text(
                      AppConstants.appName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      "Precision & Engineering Excellence",
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryBlue.withOpacity(0.6),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Loader & Version
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(
                  width: 40,
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                    minHeight: 2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "v2.4.1",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}