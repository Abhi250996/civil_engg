import 'package:flutter/material.dart';
import '../../../data/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const ReportCard({
    super.key,
    required this.report,
    required this.onOpen,
    required this.onDelete,
  });

  // Color Tokens
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6);  // Sky Blue
  static const Color borderColor = Color(0xFFE5E7EB); // Light Gray

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onOpen,
          hoverColor: accentBlue.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER: Title + Delete
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded, size: 22, color: accentBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: primaryBlue,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            report.reportType.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryBlue.withOpacity(0.4),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 20),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// METADATA SECTION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: primaryBlue.withOpacity(0.7), height: 1.4),
                      ),
                      const Spacer(),
                      _infoBadge(Icons.person_outline, report.author ?? "Unknown"),
                    ],
                  ),
                ),

                const Divider(height: 24, thickness: 0.5),

                /// FOOTER: Status + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusChip(report.status ?? "Draft"),
                    Text(
                      report.createdAt.toLocal().toString().split(" ")[0],
                      style: TextStyle(fontSize: 10, color: primaryBlue.withOpacity(0.4), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: accentBlue),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String status) {
    bool isApproved = status.toLowerCase() == 'approved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.withOpacity(0.1) : accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: isApproved ? Colors.green : accentBlue,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}