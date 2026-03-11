import 'package:flutter/material.dart';
import '../../drawing_engine/drawing_object.dart';
import '../../drawing_engine/grid_system.dart';

class DrawingCanvasWidget extends StatefulWidget {
  final List<DrawingObject> objects;

  const DrawingCanvasWidget({super.key, required this.objects});

  @override
  State<DrawingCanvasWidget> createState() => _DrawingCanvasWidgetState();
}

class _DrawingCanvasWidgetState extends State<DrawingCanvasWidget> {
  DrawingObject? selectedObject;

  Offset? lastPosition;

  final TransformationController _transformController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformController,
      minScale: 0.3,
      maxScale: 6,

      child: GestureDetector(
        onPanStart: (details) {
          final pos = details.localPosition;

          for (final obj in widget.objects.reversed) {
            if (obj.hitTest(pos)) {
              selectedObject = obj;
              lastPosition = pos;
              break;
            }
          }
        },

        onPanUpdate: (details) {
          if (selectedObject != null && lastPosition != null) {
            /// snap movement to grid
            final snapped = GridSystem.snapToGrid(details.localPosition);

            final delta = snapped - lastPosition!;

            selectedObject!.translate(delta);

            lastPosition = snapped;

            setState(() {});
          }
        },

        onPanEnd: (_) {
          selectedObject = null;
        },

        child: CustomPaint(
          size: const Size(2000, 2000),
          painter: _DrawingPainter(widget.objects, selectedObject),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingObject> objects;
  final DrawingObject? selected;

  _DrawingPainter(this.objects, this.selected);

  @override
  void paint(Canvas canvas, Size size) {
    /// background
    final backgroundPaint = Paint()..color = Colors.white;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    /// draw grid
    _drawGrid(canvas, size);

    /// draw objects
    for (final object in objects) {
      object.draw(canvas, size);

      /// highlight selected
      if (object == selected) {
        final paint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        object.drawBounds(canvas, paint);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    const gridSize = 20.0;

    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
