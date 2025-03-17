import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Utils/Api.dart';
import 'package:reside_smart_flutter/Utils/GlobalFunctions.dart';

class AuthController extends GetxController with GlobalFunctions {
  UserModel? user;
  var isLoggedIn = false.obs;
  var fieldErrors = <String, String>{}.obs;

  @override
  void onInit() {
    redirect();
    super.onInit();
  }

  Future<void> redirect() async {
    var token = await GetStorage().read('login_token');

    Future.delayed(Duration(seconds: 3), () async {
      if (token != null) {
        isLoggedIn.value = true;

        var isFetches = await getUser();
        if (!isFetches) {
          Get.snackbar('Error', 'An error occurred while fetching user data.');
          GetStorage().remove('login_token');
          isLoggedIn.value = false;
          Get.offAllNamed('landing');
          return;
        }

        print(user);
        Get.offAndToNamed('home');
      } else {
        Get.offAndToNamed('landing');
      }
    });
  }

  Future<bool> EnableGPS(String email, String password) async {
    fieldErrors.clear(); // Clear errors before each request
    try {
      final response = await Api.dio.post(
        '/signIn',
        queryParameters: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = (response.data['data']);
        user = UserModel.fromJson({...data['user'], 'token': data['token']});

        GetStorage().write('login_token', user?.token);
        return true; // Success
      }

      return false; // General error
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0]; // Store the first error message
        });
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ?? 'An error occurred';
      }
      return false;
    }
  }

  Future<bool> signUp(
    String fullName,
    String username,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    fieldErrors.clear();
    try {
      final response = await Api.dio.post(
        '/register',
        queryParameters: {
          'full_name': fullName,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        final data = (response.data['data']);
        user = UserModel.fromJson({...data['user'], 'token': data['token']});

        GetStorage().write('login_token', user?.token);
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0];
        });
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ?? 'An error occurred';
      }
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final response = await Api.dio.post('/logout');

      if (response.statusCode == 200) {
        await GetStorage().remove('login_token');
        isLoggedIn.value = false;
        Get.offAllNamed('splash');
      }
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<bool> getUser() async {
    try {
      final response = await Api.dio.get('/me');

      if (response.statusCode == 200) {
        final data = (response.data['data']);
        user = UserModel.fromJson(data);

        return true;
      }

      return false;
    } on DioException catch (e) {
      print(e);
      return false;
    }
  }
}
