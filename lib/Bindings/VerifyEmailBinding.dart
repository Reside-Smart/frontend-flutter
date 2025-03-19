import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/VerifyEmailController.dart';

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyEmailController());
  }
}
