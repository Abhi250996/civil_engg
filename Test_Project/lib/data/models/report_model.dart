import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String projectId;

  /// BASIC INFO
  final String title;
  final String description;
  final String reportType;

  /// FILE INFO
  final String filePath;
  final String? fileFormat;
  final double? fileSize;

  /// ENGINEERING METADATA
  final String? category; // Structural, Geotechnical, Electrical, etc.
  final String? department;

  /// AUTHOR INFO
  final String? author;
  final String? engineer;
  final String? organization;

  /// APPROVAL
  final String? status; // Draft, Submitted, Approved, Rejected
  final String? approvedBy;

  /// VERSION CONTROL
  final int? version;
  final String? revision;

  /// LOCATION / SITE
  final String? location;
  final double? latitude;
  final double? longitude;

  /// TAGS
  final List<String>? tags;

  /// DATES
  final DateTime? reportDate;
  final DateTime? approvedDate;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.reportType,
    required this.filePath,
    required this.createdAt,

    this.fileFormat,
    this.fileSize,

    this.category,
    this.department,

    this.author,
    this.engineer,
    this.organization,

    this.status,
    this.approvedBy,

    this.version,
    this.revision,

    this.location,
    this.latitude,
    this.longitude,

    this.tags,

    this.reportDate,
    this.approvedDate,
  });

  /// =========================
  /// FROM JSON
  /// =========================

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return ReportModel(
      id: json['id']?.toString() ?? '',
      projectId: json['projectId']?.toString() ?? '',

      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reportType: json['reportType'] ?? '',

      filePath: json['filePath'] ?? '',
      fileFormat: json['fileFormat'],
      fileSize: (json['fileSize'] ?? 0).toDouble(),

      category: json['category'],
      department: json['department'],

      author: json['author'],
      engineer: json['engineer'],
      organization: json['organization'],

      status: json['status'],
      approvedBy: json['approvedBy'],

      version: json['version'],
      revision: json['revision'],

      location: json['location'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),

      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,

      reportDate: json['reportDate'] != null
          ? parseDate(json['reportDate'])
          : null,

      approvedDate: json['approvedDate'] != null
          ? parseDate(json['approvedDate'])
          : null,

      createdAt: parseDate(json['createdAt']),
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
      "reportType": reportType,

      "filePath": filePath,
      "fileFormat": fileFormat,
      "fileSize": fileSize,

      "category": category,
      "department": department,

      "author": author,
      "engineer": engineer,
      "organization": organization,

      "status": status,
      "approvedBy": approvedBy,

      "version": version,
      "revision": revision,

      "location": location,
      "latitude": latitude,
      "longitude": longitude,

      "tags": tags,

      "reportDate": reportDate?.toIso8601String(),
      "approvedDate": approvedDate?.toIso8601String(),

      "createdAt": createdAt.toIso8601String(),
    };
  }
}
