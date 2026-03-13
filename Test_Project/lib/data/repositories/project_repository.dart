import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/project_model.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// =========================
  /// GET USER ID
  /// =========================

  String _getUid() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return user.uid;
  }

  /// =========================
  /// PROJECT COLLECTION
  /// =========================

  CollectionReference<Map<String, dynamic>> _projectRef() {
    return _firestore.collection("users").doc(_getUid()).collection("projects");
  }

  /// =========================
  /// GET PROJECTS
  /// =========================

  Future<List<ProjectModel>> getProjects() async {
    final snapshot = await _projectRef()
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ProjectModel.fromJson({...doc.data(), "id": doc.id}))
        .toList();
  }

  /// =========================
  /// REALTIME PROJECT STREAM
  /// =========================

  Stream<List<ProjectModel>> streamProjects() {
    return _projectRef()
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProjectModel.fromJson({...doc.data(), "id": doc.id}),
              )
              .toList(),
        );
  }

  /// =========================
  /// CREATE PROJECT
  /// =========================

  Future<ProjectModel> createProject({
    required String name,
    required String description,

    String? projectCategory,
    String? projectSubType,

    double? siteArea,
    double? length,
    double? width,
    double? elevation,

    String? location,
    double? latitude,
    double? longitude,

    String? soilType,
    String? foundationType,
    String? structureType,
    String? materialGrade,
    String? seismicZone,
    String? designCode,

    double? budget,
    String? contractor,
    String? consultant,
    String? projectStatus,
    String? projectStage,

    DateTime? startDate,
    DateTime? completionDate,
  }) async {
    final data = {
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

      "startDate": startDate,
      "completionDate": completionDate,

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };

    final docRef = await _projectRef().add(data);

    final doc = await docRef.get();

    return ProjectModel.fromJson({...doc.data()!, "id": doc.id});
  }

  /// =========================
  /// UPDATE PROJECT
  /// =========================

  Future<ProjectModel> updateProject({
    required String projectId,
    required Map<String, dynamic> data,
  }) async {
    final ref = _projectRef().doc(projectId);

    await ref.update({...data, "updatedAt": FieldValue.serverTimestamp()});

    final doc = await ref.get();

    return ProjectModel.fromJson({...doc.data()!, "id": doc.id});
  }

  /// =========================
  /// DELETE PROJECT
  /// =========================

  Future<void> deleteProject(String projectId) async {
    await _projectRef().doc(projectId).delete();
  }
}
