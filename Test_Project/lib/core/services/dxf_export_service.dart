import 'dart:io';

import '../../features/drawing_engine/drawing_object.dart';
import '../../features/drawing_engine/line_object.dart';
import '../../features/drawing_engine/circle_object.dart';
import '../../features/drawing_engine/text_object.dart';

class DxfExportService {
  static Future<File> exportDXF(List<DrawingObject> objects) async {
    final buffer = StringBuffer();

    /// DXF HEADER
    buffer.writeln("0");
    buffer.writeln("SECTION");
    buffer.writeln("2");
    buffer.writeln("ENTITIES");

    for (var obj in objects) {
      if (obj is LineObject) {
        buffer.writeln("0");
        buffer.writeln("LINE");

        buffer.writeln("10");
        buffer.writeln(obj.start.dx);

        buffer.writeln("20");
        buffer.writeln(obj.start.dy);

        buffer.writeln("11");
        buffer.writeln(obj.end.dx);

        buffer.writeln("21");
        buffer.writeln(obj.end.dy);
      }

      if (obj is CircleObject) {
        buffer.writeln("0");
        buffer.writeln("CIRCLE");

        buffer.writeln("10");
        buffer.writeln(obj.center.dx);

        buffer.writeln("20");
        buffer.writeln(obj.center.dy);

        buffer.writeln("40");
        buffer.writeln(obj.radius);
      }

      if (obj is TextObject) {
        buffer.writeln("0");
        buffer.writeln("TEXT");

        buffer.writeln("10");
        buffer.writeln(obj.position.dx);

        buffer.writeln("20");
        buffer.writeln(obj.position.dy);

        buffer.writeln("1");
        buffer.writeln(obj.text);
      }
    }

    buffer.writeln("0");
    buffer.writeln("ENDSEC");
    buffer.writeln("0");
    buffer.writeln("EOF");

    final file = File("drawing.dxf");

    await file.writeAsString(buffer.toString());

    return file;
  }
}
