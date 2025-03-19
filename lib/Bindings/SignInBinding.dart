import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/SignInController.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
