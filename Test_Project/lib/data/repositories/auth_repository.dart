import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =========================
  /// LOGIN
  /// =========================

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("Login failed: user not found.");
      }

      final doc = await _firestore.collection("users").doc(user.uid).get();

      final data = doc.data() ?? {};

      return UserModel(
        id: user.uid,
        name: data["name"] ?? "",
        email: user.email ?? "",
        token: user.uid,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Login Error Code: ${e.code}");
      debugPrint("Firebase Login Error Message: ${e.message}");

      throw Exception(_mapFirebaseError(e.code));
    } catch (e, stackTrace) {
      debugPrint("Login Unknown Error: $e");
      debugPrintStack(stackTrace: stackTrace);

      throw Exception("Login failed. Please try again.");
    }
  }

  /// =========================
  /// SIGNUP
  /// =========================

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("Signup failed.");
      }

      /// Save user profile
      await _firestore.collection("users").doc(user.uid).set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return UserModel(id: user.uid, name: name, email: email, token: user.uid);
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Signup Error Code: ${e.code}");
      debugPrint("Firebase Signup Error Message: ${e.message}");

      throw Exception(_mapFirebaseError(e.code));
    } catch (e, stackTrace) {
      debugPrint("Signup Unknown Error: $e");
      debugPrintStack(stackTrace: stackTrace);

      throw Exception("Signup failed. Please try again.");
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================

  Future<void> logout() async {
    await _auth.signOut();
  }

  /// =========================
  /// RESET PASSWORD
  /// =========================

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// =========================
  /// FIREBASE ERROR MAPPER
  /// =========================

  String _mapFirebaseError(String code) {
    switch (code) {
      case "user-not-found":
        return "No account found with this email.";

      case "wrong-password":
        return "Incorrect password.";

      case "invalid-email":
        return "Invalid email address.";

      case "email-already-in-use":
        return "Email already registered.";

      case "weak-password":
        return "Password should be at least 6 characters.";

      case "user-disabled":
        return "This account has been disabled.";

      default:
        return "Authentication error. Please try again.";
    }
  }
}
