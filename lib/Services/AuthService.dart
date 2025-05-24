import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart%20';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class AuthService extends GetxService {
  UserModel? globalUser;
  RxBool isLoggedIn = false.obs;

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

        try {
          globalUser = await getLoggedInUser();
          isLoggedIn.value = true;
          AppDialog.showSuccess('Logged In Successfully!');
          Get.offAllNamed('navbar');
        } catch (e) {
          AppDialog.showError('An error occurred while fetching user data.');
          GetStorage().remove('login_token');
          isLoggedIn.value = false;
          Get.offAllNamed('landing');
        }
        print(globalUser);
      } else {
        Get.offAndToNamed('landing');
      }
    });
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final response = await Api.dio.post(
      '/register',
      data: {
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      },
    );

    final UserModel user = UserModel.fromJson(response.data['user']);

    return user;
  }

  Future<UserModel> getLoggedInUser() async {
    final response = await Api.dio.get('/me');

    final data = (response.data);
    print(data);
    return UserModel.fromJson(data['user']);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await Api.dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    final UserModel user = UserModel.fromJson({
      ...response.data['user'],
      'token': response.data['token'],
    });

    GetStorage().write('login_token', user.token);
    return user;
  }

  Future<UserModel> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await Api.dio.post(
      '/email/verify',
      data: {'email': email, 'otp': otp},
    );

    final UserModel user = UserModel.fromJson({
      ...response.data['user'],
      'token': response.data['token'],
    });

    GetStorage().write('login_token', user.token);
    return user;
  }

  Future<void> logout() async {
    try {
      final response = await Api.dio.post('/logout');

      if (response.statusCode == 200) {
        await GetStorage().remove('login_token');
        isLoggedIn.value = false;
        globalUser = null;
        Get.offAllNamed('signIn');
      }
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<bool> forgetPassword({required String email}) async {
    await Api.dio.post('/forget-password', data: {'email': email});

    return true;
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await Api.dio.put(
      '/user/change-password',
      data: {
        'current_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
    );
  }

  Future<UserModel> editProfile({required dio.FormData form}) async {
    final response = await Api.dio.post('/user/edit-profile', data: form);
    print(response);
    final UserModel user = UserModel.fromJson({...response.data['user']});

    return user;
  }

  Future<UserModel> completeprofile({required dio.FormData form}) async {
    final response = await Api.dio.post('/complete-profile', data: form);
    print(response);
    final UserModel user = UserModel.fromJson({...response.data['user']});

    return user;
  }

  // Add a new method to handle session expiration

  Future<void> handleSessionExpiration() async {
    await GetStorage().remove('login_token');
    isLoggedIn.value = false;
    globalUser = null;
    AppDialog.showError("Your session has expired. Please sign in again.");
    Get.offAllNamed('/signIn');
  }
}
