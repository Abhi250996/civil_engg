class CalculationModel {
  final String id;
  final String projectId;
  final String type;
  final Map<String, dynamic> inputs;
  final Map<String, dynamic> results;
  final DateTime createdAt;

  CalculationModel({
    required this.id,
    required this.projectId,
    required this.type,
    required this.inputs,
    required this.results,
    required this.createdAt,
  });

  /// =========================
  /// FROM JSON
  /// =========================

  factory CalculationModel.fromJson(Map<String, dynamic> json) {
    return CalculationModel(
      id: json['id']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',
      type: json['type'] ?? '',
      inputs: Map<String, dynamic>.from(json['inputs'] ?? {}),
      results: Map<String, dynamic>.from(json['results'] ?? {}),
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
      "type": type,
      "inputs": inputs,
      "results": results,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  /// =========================
  /// COPY WITH
  /// =========================

  CalculationModel copyWith({
    String? id,
    String? projectId,
    String? type,
    Map<String, dynamic>? inputs,
    Map<String, dynamic>? results,
    DateTime? createdAt,
  }) {
    return CalculationModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      inputs: inputs ?? this.inputs,
      results: results ?? this.results,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
