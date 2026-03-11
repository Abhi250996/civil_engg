class ProjectModel {
  final String id;
  final String name;
  final String description;
  final double length;
  final double width;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.length,
    required this.width,
    required this.createdAt,
  });

  /// =========================
  /// FROM JSON
  /// =========================

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// =========================
  /// TO JSON
  /// =========================

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "length": length,
      "width": width,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  /// =========================
  /// COPY WITH
  /// =========================

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    double? length,
    double? width,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      length: length ?? this.length,
      width: width ?? this.width,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
