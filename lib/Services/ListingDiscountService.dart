import 'package:dio/dio.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class ListingDiscountService {
  Future<List<ListingDiscountModel>> getAllDiscounts() async {
    final response = await Api.dio.get('/listing-discounts');
    return (response.data['data'] as List)
        .map((json) => ListingDiscountModel.fromJson(json))
        .toList();
  }

  Future<List<ListingDiscountModel>> getUserDiscounts(String status) async {
    try {
      final response = await Api.dio.get(
        '/user-listing-discounts',
        queryParameters: {'status': status.toLowerCase()},
      );

      if (response.statusCode == 200) {
        List data = response.data['discounts'];
        return data.map((e) => ListingDiscountModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch discounts');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addDiscount({required dio.FormData formData}) async {
    try {
      print('server: ${formData.fields}');

      final response = await Api.dio.post(
        '/add-discounts',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      print('response: ${response.data}');

      AppDialog.showSuccess(response.data['message']);
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
    }
  }

  Future<void> deleteDiscount(int discountId) async {
    try {
      print(discountId);
      final response = await Api.dio.delete('/delete-discount/$discountId');

      print(response);
      AppDialog.showSuccess(response.data['message']);

      if (response.statusCode == 200) {
        print('Discount deleted successfully');
      } else {
        print('Failed to delete discount from server');
      }
    } catch (e) {
      print('Error deleting discount: $e');
    }
  }
}
