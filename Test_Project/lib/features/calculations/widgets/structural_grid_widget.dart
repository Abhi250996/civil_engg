import 'package:flutter/material.dart';

class StructuralGridWidget extends StatelessWidget {
  final double length;
  final double width;
  final double columnSpacing;

  const StructuralGridWidget({
    super.key,
    required this.length,
    required this.width,
    required this.columnSpacing,
  });

  @override
  Widget build(BuildContext context) {
    int columnsX = (length / columnSpacing).floor() + 1;
    int columnsY = (width / columnSpacing).floor() + 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        double cellWidth = constraints.maxWidth / columnsX;
        double cellHeight = constraints.maxHeight / columnsY;

        return Stack(
          children: [
            /// GRID LINES
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _GridPainter(columnsX: columnsX, columnsY: columnsY),
            ),

            /// COLUMN POINTS
            ...List.generate(columnsX, (x) {
              return List.generate(columnsY, (y) {
                return Positioned(
                  left: x * cellWidth - 4,
                  top: y * cellHeight - 4,

                  child: Container(
                    width: 8,
                    height: 8,

                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              });
            }).expand((e) => e),
          ],
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final int columnsX;
  final int columnsY;

  _GridPainter({required this.columnsX, required this.columnsY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    double cellWidth = size.width / columnsX;
    double cellHeight = size.height / columnsY;

    /// Vertical lines
    for (int i = 0; i <= columnsX; i++) {
      double x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    /// Horizontal lines
    for (int j = 0; j <= columnsY; j++) {
      double y = j * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
