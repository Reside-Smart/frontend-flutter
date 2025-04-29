import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/SearchController.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}
