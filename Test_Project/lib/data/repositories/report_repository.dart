import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/report_model.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// =========================
  /// GET ALL REPORTS
  /// =========================

  Future<List<ReportModel>> getReports() async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("reports")
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ReportModel.fromJson({...doc.data(), "id": doc.id}))
        .toList();
  }

  /// =========================
  /// CREATE REPORT
  /// =========================

  Future<ReportModel> createReport({
    required String projectId,
    required String title,
    required String description,
    required String filePath,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final docRef = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("reports")
        .add({
          "projectId": projectId,
          "title": title,
          "description": description,
          "filePath": filePath,
          "createdAt": FieldValue.serverTimestamp(),
        });

    final doc = await docRef.get();

    return ReportModel.fromJson({...doc.data()!, "id": doc.id});
  }

  /// =========================
  /// DELETE REPORT
  /// =========================

  Future<void> deleteReport(String reportId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("reports")
        .doc(reportId)
        .delete();
  }
}
