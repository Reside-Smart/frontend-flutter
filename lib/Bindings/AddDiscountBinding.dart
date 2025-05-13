import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/AddDiscountController.dart';

class AddDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddDiscountController());
  }
}
