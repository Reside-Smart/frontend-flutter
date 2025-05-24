import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class SignUpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;
  // Track registration status
  final RxBool registrationComplete = false.obs;

  Future<void> registerUser(
    String name,
    String email,
    String phoneNumber,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      // Validate password confirmation before making API call
      if (password != passwordConfirmation) {
        fieldErrors['password_confirmation'] = 'Passwords do not match';
        isLoading.value = false;
        return;
      }

      final UserModel user = await _authService.register(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      _authService.globalUser = user;
      registrationComplete.value = true;
      AppDialog.showSuccess(
        "Registration successful! Please verify your email.",
      );
      Get.offAllNamed('/verifyEmail');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
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
            'An error occurred during registration. Please try again.';
        AppDialog.showError(fieldErrors['general'] ?? 'Registration failed');
      }
    } catch (_) {
      fieldErrors['general'] =
          'Unexpected error occurred. Please check your connection.';
      AppDialog.showError(fieldErrors['general'] ?? 'Registration failed');
    }
  }
}
