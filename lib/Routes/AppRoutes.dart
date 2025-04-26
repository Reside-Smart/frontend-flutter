import 'package:reside_smart_flutter/Bindings/AddListingBinding.dart';
import 'package:reside_smart_flutter/Bindings/SignInBinding.dart';
import 'package:reside_smart_flutter/Bindings/SignUpBinding.dart';
import 'package:reside_smart_flutter/Bindings/ForgetPasswordBinding.dart';
import 'package:reside_smart_flutter/Bindings/UpdateListingBinding.dart';
import 'package:reside_smart_flutter/Bindings/VerifyEmailBinding.dart';
import 'package:reside_smart_flutter/Bindings/ChangePasswordBinding.dart';
import 'package:reside_smart_flutter/Bindings/EditProfileBinding.dart';
import 'package:reside_smart_flutter/Bindings/CompleteProfileBinding.dart';
import 'package:reside_smart_flutter/Bindings/ListingsBinding.dart';
import 'package:reside_smart_flutter/Views/ForgetPassword.dart';
import 'package:reside_smart_flutter/Views/HomePage.dart';
import 'package:reside_smart_flutter/Views/Landing.dart';
import 'package:reside_smart_flutter/Views/SignIn.dart';
import 'package:reside_smart_flutter/Views/SignUp.dart';
import 'package:reside_smart_flutter/Views/Splash.dart';
import 'package:reside_smart_flutter/Views/BottomNavBar.dart';
import 'package:reside_smart_flutter/Views/EditProfile.dart';
import 'package:reside_smart_flutter/Views/ChangePassword.dart';
import 'package:reside_smart_flutter/Views/ListingsPage.dart';
import 'package:reside_smart_flutter/Views/AddListing.dart';
import 'package:reside_smart_flutter/Views/Completeprofile.dart';

import 'package:get/get.dart';
import 'package:reside_smart_flutter/Views/UpdateListing.dart';
import 'package:reside_smart_flutter/Views/VerifyEmail.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String verifyEmail = '/verifyEmail';
  static const String completeProfile = '/completeProfile';
  static const String forgetPassword = '/forget-password';
  static const String home = '/home';
  static const String navbar = '/navbar';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String listing = '/listing';
  static const String addListing = '/add-listing';
  static const String updateListing = '/Update-listing';

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
      name: completeProfile,
      page: () => Completeprofile(),
      binding: Completeprofilebinding(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: navbar, page: () => BottomNavBar()),
    GetPage(
      name: '/edit-profile',
      page: () => EditProfile(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: '/change-password',
      page: () => Changepassword(),
      binding: Changepasswordbinding(),
    ),
    GetPage(
      name: listing,
      page: () => ListingsPage(),
      binding: Listingsbinding(),
    ),
    GetPage(
      name: addListing,
      page: () => AddListingPage(),
      binding: AddListingBinding(),
    ),
    GetPage(
      name: updateListing,
      page: () => UpdateListingPage(),
      binding: Updatelistingbinding(),
    ),
  ];
}
