import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';

class ListingDiscountService {
  Future<List<ListingDiscountModel>> getAllDiscounts() async {
    final response = await Api.dio.get('/listing-discounts');
    return (response.data['data'] as List)
        .map((json) => ListingDiscountModel.fromJson(json))
        .toList();
  }
}
