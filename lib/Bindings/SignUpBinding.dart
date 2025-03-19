import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/SignUpController.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
