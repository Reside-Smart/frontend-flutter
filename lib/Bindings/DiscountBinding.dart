import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/DiscountController.dart';

class DiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscountController());
  }
}
