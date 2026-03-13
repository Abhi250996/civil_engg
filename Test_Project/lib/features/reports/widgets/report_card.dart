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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onOpen,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  const Icon(Icons.description, color: Colors.blue, size: 28),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      report.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// DESCRIPTION
              Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const SizedBox(height: 12),

              /// REPORT TYPE
              _infoRow("Type", report.reportType),

              /// AUTHOR
              _infoRow("Author", report.author ?? "-"),

              /// STATUS
              if (report.status != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    report.status!,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),

              const Spacer(),

              /// DATE
              Text(
                report.createdAt.toLocal().toString().split(" ")[0],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),

      child: Text("$label: $value", style: const TextStyle(fontSize: 13)),
    );
  }
}
