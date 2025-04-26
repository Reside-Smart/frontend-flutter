import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/EditProfileController.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}
