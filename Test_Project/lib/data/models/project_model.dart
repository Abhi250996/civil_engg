import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;

  /// PROJECT CLASSIFICATION
  final String? projectCategory;
  // Building, Bridge, Dam, PowerPlant, Road, Airport, etc.

  final String? projectSubType;

  /// SITE INFORMATION
  final double? siteArea;
  final double? length;
  final double? width;
  final double? elevation;

  final String? location;
  final double? latitude;
  final double? longitude;

  /// ENGINEERING PARAMETERS
  final String? soilType;
  final String? foundationType;
  final String? structureType;
  final String? materialGrade;

  final String? seismicZone;
  final String? designCode;

  /// PROJECT MANAGEMENT
  final double? budget;
  final String? contractor;
  final String? consultant;
  final String? projectStatus;
  final String? projectStage;

  /// TIMELINE
  final DateTime? startDate;
  final DateTime? completionDate;

  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,

    this.projectCategory,
    this.projectSubType,

    this.siteArea,
    this.length,
    this.width,
    this.elevation,

    this.location,
    this.latitude,
    this.longitude,

    this.soilType,
    this.foundationType,
    this.structureType,
    this.materialGrade,

    this.seismicZone,
    this.designCode,

    this.budget,
    this.contractor,
    this.consultant,
    this.projectStatus,
    this.projectStage,

    this.startDate,
    this.completionDate,
  });

  /// =========================
  /// FROM JSON
  /// =========================

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return ProjectModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",

      projectCategory: json["projectCategory"],
      projectSubType: json["projectSubType"],

      siteArea: (json["siteArea"] ?? 0).toDouble(),
      length: (json["length"] ?? 0).toDouble(),
      width: (json["width"] ?? 0).toDouble(),
      elevation: (json["elevation"] ?? 0).toDouble(),

      location: json["location"],
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),

      soilType: json["soilType"],
      foundationType: json["foundationType"],
      structureType: json["structureType"],
      materialGrade: json["materialGrade"],

      seismicZone: json["seismicZone"],
      designCode: json["designCode"],

      budget: (json["budget"] ?? 0).toDouble(),
      contractor: json["contractor"],
      consultant: json["consultant"],
      projectStatus: json["projectStatus"],
      projectStage: json["projectStage"],

      startDate: json["startDate"] != null
          ? parseDate(json["startDate"])
          : null,
      completionDate: json["completionDate"] != null
          ? parseDate(json["completionDate"])
          : null,

      createdAt: parseDate(json["createdAt"]),
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

      "projectCategory": projectCategory,
      "projectSubType": projectSubType,

      "siteArea": siteArea,
      "length": length,
      "width": width,
      "elevation": elevation,

      "location": location,
      "latitude": latitude,
      "longitude": longitude,

      "soilType": soilType,
      "foundationType": foundationType,
      "structureType": structureType,
      "materialGrade": materialGrade,

      "seismicZone": seismicZone,
      "designCode": designCode,

      "budget": budget,
      "contractor": contractor,
      "consultant": consultant,
      "projectStatus": projectStatus,
      "projectStage": projectStage,

      "startDate": startDate?.toIso8601String(),
      "completionDate": completionDate?.toIso8601String(),

      "createdAt": createdAt.toIso8601String(),
    };
  }
}
