import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CadViewerScreen extends StatefulWidget {
  const CadViewerScreen({super.key});

  @override
  State<CadViewerScreen> createState() => _CadViewerScreenState();
}

class _CadViewerScreenState extends State<CadViewerScreen> {
  /// THEME
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF8FAFC);

  File? drawingFile;
  Uint8List? drawingBytes;
  String? fileName;

  final TextEditingController annotationController = TextEditingController();

  /// PICK FILE
  Future<void> pickDrawing() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "dwg", "dxf"],
      withData: true,
    );

    if (result != null) {
      fileName = result.files.single.name;

      /// WEB
      if (kIsWeb) {
        drawingBytes = result.files.single.bytes;
      }
      /// MOBILE / DESKTOP
      else {
        drawingFile = File(result.files.single.path!);
      }

      setState(() {});
    }
  }

  /// TOOL CARD
  Widget toolCard(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentBlue, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// ADD NOTE
  void addAnnotation() {
    if (annotationController.text.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Annotation added: ${annotationController.text}")),
    );

    annotationController.clear();
  }

  /// DRAWING VIEWER
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        title: const Text(
          "CAD DRAWING VIEWER",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 14,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// FILE HEADER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fileName ?? "No drawing loaded",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: pickDrawing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "OPEN DRAWING",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// DRAWING VIEWER
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),

                child: drawingViewer(),
              ),
            ),

            const SizedBox(height: 10),

            /// TOOL GRID
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.6,

              children: [
                toolCard(Icons.zoom_in, "Zoom", () {}),

                toolCard(Icons.straighten, "Measure", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Measurement tool coming soon"),
                    ),
                  );
                }),

                toolCard(Icons.layers, "Layers", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Layer control coming soon")),
                  );
                }),

                toolCard(Icons.edit, "Markup", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Markup tool coming soon")),
                  );
                }),
              ],
            ),

            const SizedBox(height: 10),

            /// ANNOTATION INPUT
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
                  height: 40,
                  child: ElevatedButton(
                    onPressed: addAnnotation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("ADD", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
