import 'package:reside_smart_flutter/Utils/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin GlobalFunctions {
  void showLoadingDialog() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void closeLoadingDialog() {
    print(Get.isDialogOpen);
    if (Get.isDialogOpen! == true) {
      Get.back();
    }
  }
}
