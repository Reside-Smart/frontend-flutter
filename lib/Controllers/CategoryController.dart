import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/CategoryModel.dart';
import 'package:reside_smart_flutter/Services/CategoryService.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();

  var categories = <Category>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _categoryService.getCategories();
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
