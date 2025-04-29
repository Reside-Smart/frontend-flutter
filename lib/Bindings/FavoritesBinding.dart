import 'package:get/get.dart';
import 'package:reside_smart_flutter/Controllers/FavoritesController.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController());
  }
}
