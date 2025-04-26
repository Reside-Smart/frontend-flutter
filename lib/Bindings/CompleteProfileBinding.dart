import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/CompleteProfileController.dart';

class Completeprofilebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompleteProfileController());
  }
}
