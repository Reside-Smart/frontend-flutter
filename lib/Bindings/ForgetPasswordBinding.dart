import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/ForgetPasswordController.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordController());
  }
}
