import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/FilterController.dart';

class FilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterController());
  }
}
