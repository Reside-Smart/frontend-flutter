import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AuthController.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    // Get.put(BottomNavController(), permanent: true);
  }
}
