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

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLocked ? null : onTap,
      borderRadius: BorderRadius.circular(14),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isLocked ? borderColor.withOpacity(0.5) : borderColor,
          ),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),

        padding: const EdgeInsets.all(14),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON CONTAINER
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.withOpacity(0.1)
                    : accentBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isLocked ? Colors.grey : accentBlue,
                size: 26,
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isLocked ? Colors.grey : primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 11,
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
                  color: primaryBlue.withOpacity(0.5),
                ),
              ),
            ],

            /// LOCK ICON
            if (isLocked) ...[
              const SizedBox(height: 6),
              const Icon(Icons.lock, size: 14, color: Colors.grey),
            ],
          ],
        ),
      ),
    );
  }
}
