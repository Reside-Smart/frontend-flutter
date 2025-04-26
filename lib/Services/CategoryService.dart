import 'package:dio/dio.dart';
import 'package:reside_smart_flutter/Models/CategoryModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    final response = await Api.dio.get('/categories');
    final List data = response.data['categories'];
    return data.map((json) => Category.fromJson(json)).toList();
  }
}
