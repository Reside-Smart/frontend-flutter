import 'package:reside_smart_flutter/Bindings/SignInBinding.dart';
import 'package:reside_smart_flutter/Bindings/SignUpBinding.dart';
import 'package:reside_smart_flutter/Bindings/ForgetPasswordBinding.dart';
import 'package:reside_smart_flutter/Bindings/VerifyEmailBinding.dart';
import 'package:reside_smart_flutter/Views/ForgetPassword.dart';
import 'package:reside_smart_flutter/Views/HomePage.dart';
import 'package:reside_smart_flutter/Views/Landing.dart';
import 'package:reside_smart_flutter/Views/SignIn.dart';
import 'package:reside_smart_flutter/Views/SignUp.dart';
import 'package:reside_smart_flutter/Views/Splash.dart';

import 'package:get/get.dart';
import 'package:reside_smart_flutter/Views/VerifyEmail.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String verifyEmail = '/verifyEmail';
  static const String forgetPassword = '/forget-password';
  static const String home = '/home';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: landing, page: () => LandingPage()),
    GetPage(name: signIn, page: () => SignInPage(), binding: SignInBinding()),
    GetPage(name: signUp, page: () => SignUpPage(), binding: SignUpBinding()),
    GetPage(
      name: verifyEmail,
      page: () => VerifyEmailPage(),
      binding: VerifyEmailBinding(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(name: home, page: () => HomePage()),
  ];
}
