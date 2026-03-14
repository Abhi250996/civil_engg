import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CadViewerScreen extends StatefulWidget {
  const CadViewerScreen({super.key});

  @override
  State<CadViewerScreen> createState() => _CadViewerScreenState();
}

class _CadViewerScreenState extends State<CadViewerScreen> {
  File? drawingFile;
  String? fileName;

  final TextEditingController annotationController = TextEditingController();

  Future<void> pickDrawing() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "dwg", "dxf"],
    );

    if (result != null) {
      setState(() {
        drawingFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }

  Widget toolButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  void addAnnotation() {
    if (annotationController.text.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Annotation added: ${annotationController.text}")),
    );

    annotationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CAD Drawing Viewer")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// FILE SECTION
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    const Text(
                      "DRAWING FILE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Text(fileName ?? "No drawing loaded"),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: pickDrawing,
                      child: const Text("OPEN DRAWING"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// VIEWER
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: drawingFile == null
                    ? const Center(child: Text("Load a drawing to view"))
                    : SfPdfViewer.file(drawingFile!),
              ),
            ),

            const SizedBox(height: 10),

            /// ENGINEERING TOOLS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                toolButton(Icons.zoom_in, "Zoom", () {}),

                toolButton(Icons.straighten, "Measure", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Measurement tool coming soon"),
                    ),
                  );
                }),

                toolButton(Icons.layers, "Layers", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Layer control coming soon")),
                  );
                }),
              ],
            ),

            const SizedBox(height: 10),

            /// ANNOTATION
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: annotationController,
                    decoration: const InputDecoration(
                      labelText: "Add Site Note",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: addAnnotation,
                  child: const Text("ADD"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
