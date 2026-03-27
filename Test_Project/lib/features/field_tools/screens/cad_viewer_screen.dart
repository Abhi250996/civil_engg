import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:build_pro/core/utils/app_scaffold.dart';

class CadViewerScreen extends StatefulWidget {
  const CadViewerScreen({super.key});

  @override
  State<CadViewerScreen> createState() => _CadViewerScreenState();
}

class _CadViewerScreenState extends State<CadViewerScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  File? drawingFile;
  Uint8List? drawingBytes;
  String? fileName;

  final TextEditingController annotationController = TextEditingController();

  /// ================= FILE PICK =================
  Future<void> pickDrawing() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "dwg", "dxf"],
      withData: true,
    );

    if (result != null) {
      fileName = result.files.single.name;

      if (kIsWeb) {
        drawingBytes = result.files.single.bytes;
      } else {
        drawingFile = File(result.files.single.path!);
      }

      setState(() {});
    }
  }

  /// ================= VIEWER =================
  Widget drawingViewer() {
    if (drawingBytes != null) {
      return SfPdfViewer.memory(drawingBytes!);
    }
    if (drawingFile != null) {
      return SfPdfViewer.file(drawingFile!);
    }

    return const Center(
      child: Text(
        "Load a drawing to view",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ================= TOOL CARD =================
  Widget toolCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentBlue, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= ANNOTATION =================
  void addAnnotation() {
    if (annotationController.text.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Annotation: ${annotationController.text}")),
    );

    annotationController.clear();
  }

  /// ================= UI =================
  bool isDesktop(double width) => width > 900;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CAD Viewer",
      showBack: true,
      child: Container(
        /// 🔥 GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SizedBox(
              width: double.infinity,

              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = isDesktop(constraints.maxWidth);

                    return Column(
                      children: [
                        /// HEADER
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                fileName ?? "No drawing loaded",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: pickDrawing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Open Drawing",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// VIEWER
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: drawingViewer(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// TOOL GRID
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: desktop ? 6 : 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.6,
                          children: [
                            toolCard(Icons.zoom_in, "Zoom", () {}),
                            toolCard(Icons.straighten, "Measure", () {}),
                            toolCard(Icons.layers, "Layers", () {}),
                            toolCard(Icons.edit, "Markup", () {}),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// ANNOTATION
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: annotationController,
                                decoration: InputDecoration(
                                  labelText: "Add Site Note",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: addAnnotation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "ADD",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
