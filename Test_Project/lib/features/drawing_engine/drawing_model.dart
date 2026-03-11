import 'drawing_object.dart';
import 'drawing_json_parser.dart';

class DrawingModel {
  /// List of all objects in the drawing
  final List<DrawingObject> objects;

  DrawingModel({required this.objects});

  /// =========================
  /// CREATE EMPTY DRAWING
  /// =========================

  factory DrawingModel.empty() {
    return DrawingModel(objects: []);
  }

  /// =========================
  /// CREATE FROM AI JSON
  /// =========================

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    final parsedObjects = DrawingJsonParser.parse(json);

    return DrawingModel(objects: parsedObjects);
  }

  /// =========================
  /// ADD OBJECT
  /// =========================

  void addObject(DrawingObject object) {
    objects.add(object);
  }

  /// =========================
  /// REMOVE OBJECT
  /// =========================

  void removeObject(String id) {
    objects.removeWhere((o) => o.id == id);
  }

  /// =========================
  /// CLEAR DRAWING
  /// =========================

  void clear() {
    objects.clear();
  }
}
