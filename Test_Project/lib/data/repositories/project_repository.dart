import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/project_model.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// =========================
  /// GET ALL PROJECTS
  /// =========================

  Future<List<ProjectModel>> getProjects() async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("projects")
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ProjectModel.fromJson({...doc.data(), "id": doc.id}))
        .toList();
  }

  /// =========================
  /// CREATE PROJECT
  /// =========================

  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required double length,
    required double width,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final docRef = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("projects")
        .add({
          "name": name,
          "description": description,
          "length": length,
          "width": width,
          "createdAt": FieldValue.serverTimestamp(),
        });

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
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final ref = _firestore
        .collection("users")
        .doc(user.uid)
        .collection("projects")
        .doc(projectId);

    await ref.update(data);

    final doc = await ref.get();

    return ProjectModel.fromJson({...doc.data()!, "id": doc.id});
  }

  /// =========================
  /// DELETE PROJECT
  /// =========================

  Future<void> deleteProject(String projectId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("projects")
        .doc(projectId)
        .delete();
  }
}
