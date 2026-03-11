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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onOpen,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              /// REPORT ICON
              const Icon(Icons.description, size: 40, color: Colors.blue),

              const SizedBox(width: 16),

              /// REPORT DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// DESCRIPTION
                    Text(
                      report.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 8),

                    /// DATE
                    Text(
                      report.createdAt.toLocal().toString().split(" ")[0],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              /// DELETE BUTTON
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
