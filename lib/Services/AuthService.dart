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
          GetStorage().remove('login_token');
          globalUser = await getLoggedInUser();
          isLoggedIn.value = true;
          AppDialog.showSuccess('Logged In Successfully!');
          Get.offAllNamed('home');
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

    final UserModel user = UserModel.fromJson({
      ...response.data['user'],
      'token': response.data['token'],
    });

    GetStorage().write('login_token', user.token);
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

  Future<bool> verifyEmail({required String email, required String otp}) async {
    await Api.dio.post('/email/verify', data: {'email': email, 'otp': otp});

    return true;
  }

  Future<bool> forgetPassword({required String email}) async {
    await Api.dio.post('/forget-password', data: {'email': email});

    return true;
  }
}
