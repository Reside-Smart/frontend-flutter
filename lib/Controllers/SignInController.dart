import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';

class SignInController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      final UserModel user = await _authService.login(
        email: email,
        password: password,
      );

      _authService.globalUser = user;
      print(_authService.globalUser);
      Get.toNamed('/home');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e.response?.statusCode == 422) {
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
