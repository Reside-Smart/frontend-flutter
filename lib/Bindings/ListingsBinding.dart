import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/ListingsController.dart';

class Listingsbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ListingsController());
  }
}
