import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  /// =========================
  /// STATE
  /// =========================
  final RxBool isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // NOTE: Humne _showLoading aur _hideLoading methods ko remove kar diya hai
  // taaki screen ke center mein extra indicator na aaye.

  /// =========================
  /// LOGIN
  /// =========================
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true; // Isse Login button load hona shuru hoga

      UserModel user = await _repository.login(
        email: email,
        password: password,
      );

      currentUser.value = user;

      if (user.token != null) {
        await StorageService.write("token", user.token);
      }

      Get.snackbar(
        "Success",
        "Login successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(RouteConstants.dashboard);
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false; // Button loading band ho jayegi
    }
  }

  /// =========================
  /// SIGNUP
  /// =========================
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      UserModel user = await _repository.signup(
        name: name,
        email: email,
        password: password,
      );

      currentUser.value = user;

      if (user.token != null) {
        await StorageService.write("token", user.token);
      }

      Get.snackbar(
        "Success",
        "Account created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(RouteConstants.dashboard);
    } catch (e) {
      Get.snackbar(
        "Signup Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _repository.logout();
      await StorageService.remove("token");
      currentUser.value = null;

      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      Get.snackbar(
        "Logout Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// CHECK LOGIN STATUS
  /// =========================
  Future<void> checkAuth() async {
    final token = StorageService.read("token");

    if (token != null) {
      Get.offAllNamed(RouteConstants.dashboard);
    } else {
      Get.offAllNamed(RouteConstants.login);
    }
  }
}