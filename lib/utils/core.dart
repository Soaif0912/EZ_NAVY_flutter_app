import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class ProductArgument{
  final int productID;
  const ProductArgument({required this.productID});
}

mixin InputValidationMixin {

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // ✅ Validate Password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}


void showLoader() {
  Get.closeAllSnackbars();
  // Close any existing dialogs
  if (Get.isDialogOpen ?? false) {
    Get.back(closeOverlays: true);
  }

  Get.dialog(
    const PopScope(
      canPop: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
    barrierDismissible: false, // Prevent tapping outside to dismiss
  );
}

void hideLoader() async{
  if (Get.isDialogOpen ?? false) {
    Get.back(); 
  }
}

void showError(String message) {
  Get.closeAllSnackbars();
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red.withOpacity(0.8),
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
  );
}

void showSuccess(String message) {
  Get.closeAllSnackbars();
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green.withOpacity(0.8),
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
  );
}