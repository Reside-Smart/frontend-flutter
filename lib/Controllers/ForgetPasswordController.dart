import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class ForgetPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      final bool sentForgetPassword = await _authService.forgetPassword(
        email: email,
      );

      if (sentForgetPassword) {
        AppDialog.showSuccess("Email Sent Successfully!");
        // Get.toNamed('/home');
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e?.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          e.response?.data['message'] ?? 'An error occurred';
    }
  }
}
