import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    // Get.put(BottomNavController(), permanent: true);
  }
}
