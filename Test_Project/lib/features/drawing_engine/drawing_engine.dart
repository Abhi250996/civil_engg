import 'drawing_object.dart';

class DrawingEngine {
  final List<DrawingObject> objects = [];

  void addObject(DrawingObject object) {
    objects.add(object);
  }

  void removeObject(String id) {
    objects.removeWhere((o) => o.id == id);
  }

  void clear() {
    objects.clear();
  }

  List<DrawingObject> getVisibleObjects() {
    return objects.where((o) => o.visible).toList();
  }
}
