import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class VerifyEmailController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  var fieldErrors = <String, String>{}.obs;
  final RxInt resendCooldown = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure we have the user's email
    if (_authService.globalUser == null ||
        _authService.globalUser!.email.isEmpty) {
      AppDialog.showError("User information missing. Please sign up again.");
      Get.offAllNamed('/signUp');
    }
  }

  Future<void> veriyfEmailUser(String otp) async {
    if (otp.isEmpty) {
      fieldErrors['otp'] = 'Please enter the verification code';
      return;
    }

    try {
      isLoading.value = true;
      fieldErrors.value = {};

      final UserModel user = await _authService.verifyEmail(
        email: _authService.globalUser!.email,
        otp: otp,
      );

      _authService.globalUser = user;
      AppDialog.showSuccess("Email verified successfully!");
      Get.offAllNamed('/completeProfile');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerificationCode() async {
    if (isResending.value || resendCooldown.value > 0) return;

    try {
      isResending.value = true;
      fieldErrors.value = {};

      // This should call an API endpoint to resend the verification code
      // For now, let's simulate this with a success message
      await Future.delayed(Duration(seconds: 1));

      AppDialog.showSuccess(
        "Verification code sent to ${_authService.globalUser!.email}",
      );

      // Start cooldown timer (60 seconds)
      resendCooldown.value = 60;
      _startCooldownTimer();
    } catch (e) {
      AppDialog.showError(
        "Failed to resend verification code. Please try again later.",
      );
    } finally {
      isResending.value = false;
    }
  }

  void _startCooldownTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      resendCooldown.value--;
      return resendCooldown.value > 0;
    });
  }

  void _handleError(e) {
    try {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0];
        });
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ??
            'Invalid verification code. Please try again.';
      }
    } catch (_) {
      fieldErrors['general'] =
          'Unexpected error occurred. Please check your connection.';
    }
  }
}
