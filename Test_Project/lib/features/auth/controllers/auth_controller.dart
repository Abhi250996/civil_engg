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

  /// =========================
  /// SHOW LOADING
  /// =========================

  void _showLoading() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void _hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// =========================
  /// LOGIN
  /// =========================

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;

      _showLoading();

      UserModel user = await _repository.login(
        email: email,
        password: password,
      );

      currentUser.value = user;

      if (user.token != null) {
        await StorageService.write("token", user.token);
      }

      _hideLoading();

      Get.snackbar(
        "Success",
        "Login successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(RouteConstants.dashboard);
    } catch (e) {
      _hideLoading();

      Get.snackbar(
        "Login Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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

      _showLoading();

      UserModel user = await _repository.signup(
        name: name,
        email: email,
        password: password,
      );

      currentUser.value = user;

      if (user.token != null) {
        await StorageService.write("token", user.token);
      }

      _hideLoading();

      Get.snackbar(
        "Success",
        "Account created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(RouteConstants.dashboard);
    } catch (e) {
      _hideLoading();

      Get.snackbar(
        "Signup Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
      _showLoading();

      await _repository.logout();

      await StorageService.remove("token");

      currentUser.value = null;

      _hideLoading();

      Get.offAllNamed(RouteConstants.login);
    } catch (e) {
      _hideLoading();

      Get.snackbar(
        "Logout Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
