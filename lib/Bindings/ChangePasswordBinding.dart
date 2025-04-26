import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/ChangePasswordController.dart';

class Changepasswordbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController());
  }
}
