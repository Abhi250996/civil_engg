import 'package:flutter/material.dart';

class ToolCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLocked;

  const ToolCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.isLocked = false,
  });

  // Color Palette from Saved Info
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color borderColor = Color(0xFFE5E7EB); // Light Gray

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        // Desktop par card ko bahut bada hone se rokne ke liye
        constraints: const BoxConstraints(
          maxWidth: 180,
          maxHeight: 180,
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLocked ? borderColor.withOpacity(0.5) : borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLocked ? null : onTap,
              borderRadius: BorderRadius.circular(16),
              hoverColor: accentBlue.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with soft background
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isLocked ? borderColor.withOpacity(0.3) : accentBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 26,
                        color: isLocked ? Colors.grey : accentBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isLocked ? Colors.grey : primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryBlue.withOpacity(0.4),
                        ),
                      ),
                    ],
                    if (isLocked) ...[
                      const SizedBox(height: 8),
                      const Text(
                        "LOCKED",
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}