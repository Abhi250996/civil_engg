import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/report_model.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// =========================
  /// USER REPORT COLLECTION
  /// =========================

  CollectionReference<Map<String, dynamic>> _reportRef(String uid) {
    return _firestore.collection("users").doc(uid).collection("reports");
  }

  /// =========================
  /// GET REPORTS
  /// =========================

  Future<List<ReportModel>> getReports() async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot = await _reportRef(
      user.uid,
    ).orderBy("createdAt", descending: true).get();

    return snapshot.docs
        .map((doc) => ReportModel.fromJson({...doc.data(), "id": doc.id}))
        .toList();
  }

  /// =========================
  /// REALTIME REPORT STREAM
  /// =========================

  Stream<List<ReportModel>> streamReports() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _reportRef(user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromJson({...doc.data(), "id": doc.id}))
              .toList(),
        );
  }

  /// =========================
  /// CREATE REPORT
  /// =========================

  Future<ReportModel> createReport({
    required String projectId,
    required String title,
    required String description,
    required String reportType,
    required String filePath,

    String? category,
    String? department,

    String? author,
    String? engineer,
    String? organization,

    String? status,
    String? approvedBy,

    int? version,
    String? revision,

    String? location,
    double? latitude,
    double? longitude,

    List<String>? tags,

    DateTime? reportDate,
    DateTime? approvedDate,

    String? fileFormat,
    double? fileSize,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final docRef = await _reportRef(user.uid).add({
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

      "reportDate": reportDate,
      "approvedDate": approvedDate,

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    final doc = await docRef.get();

    return ReportModel.fromJson({...doc.data()!, "id": doc.id});
  }

  /// =========================
  /// UPDATE REPORT
  /// =========================

  Future<ReportModel> updateReport({
    required String reportId,
    required Map<String, dynamic> data,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final ref = _reportRef(user.uid).doc(reportId);

    await ref.update({...data, "updatedAt": FieldValue.serverTimestamp()});

    final doc = await ref.get();

    return ReportModel.fromJson({...doc.data()!, "id": doc.id});
  }

  /// =========================
  /// DELETE REPORT
  /// =========================

  Future<void> deleteReport(String reportId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _reportRef(user.uid).doc(reportId).delete();
  }
}
