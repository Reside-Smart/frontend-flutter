import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/AuthService.dart';
import 'package:reside_smart_flutter/Services/CategoryService.dart';
import 'package:reside_smart_flutter/Services/ListingService.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    // Get.put(BottomNavController(), permanent: true);
    Get.put(ListingService(), permanent: true);
    Get.put(CategoryService(), permanent: true);
  }
}
