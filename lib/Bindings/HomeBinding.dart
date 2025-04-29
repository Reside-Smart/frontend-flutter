import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/HomeController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
