class ReportModel {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final String filePath;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.filePath,
    required this.createdAt,
  });

  /// =========================
  /// FROM JSON
  /// =========================

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      filePath: json['filePath'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// =========================
  /// TO JSON
  /// =========================

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "projectId": projectId,
      "title": title,
      "description": description,
      "filePath": filePath,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  /// =========================
  /// COPY WITH
  /// =========================

  ReportModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    String? filePath,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
