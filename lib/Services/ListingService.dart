import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:dio/dio.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class ListingService extends GetxService {
  Future<void> saveAsDraft({required dio.FormData formData}) async {
    print(formData.fields);
    print(formData.files);
    final response = await Api.dio.post(
      '/listings-draft',
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    print(response);
  }

  Future<void> saveAsPublished({required dio.FormData formData}) async {
    print(formData.fields);
    print(formData.files);
    final response = await Api.dio.post(
      '/listings-published',
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    print(response);
  }

  Future<List<ListingModel>> getUserListings(String status) async {
    try {
      final response = await Api.dio.get(
        '/user/listings',
        queryParameters: {'status': status.toLowerCase()},
      );

      if (response.statusCode == 200) {
        List data = response.data['listings'];
        return data.map((e) => ListingModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch listings');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListingModel>> getNearbyEstates() async {
    try {
      final response = await Api.dio.get('/nearby-estates');

      if (response.statusCode == 200) {
        List data = response.data['listings'];
        return data.map((e) => ListingModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch listings');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAsDraft({
    required int listingId,
    required dio.FormData formData,
  }) async {
    try {
      print(formData.fields);
      print(formData.files);

      final response = await Api.dio.post(
        '/listings-update-draft/$listingId',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print(response.data);

      AppDialog.showSuccess(response.data['message']);
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
    }
  }

  Future<void> updateAsPublished({
    required int listingId,
    required dio.FormData formData,
  }) async {
    try {
      print(formData.fields);
      print(formData.files);

      final response = await Api.dio.post(
        '/listings-update-published/$listingId',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print(response.data);

      AppDialog.showSuccess(response.data['message']);
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
    }
  }

  Future<ListingModel> getSingleListing(int id) async {
    try {
      final response = await Api.dio.get('/show-single-listing/$id');
      print('Full Response Data: ${response.data}');
      if (response.statusCode == 200) {
        return ListingModel.fromJson(response.data['listing']);
      } else {
        throw Exception('Failed to fetch listings');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListingModel>> searchListings({
    String? query,
    int? categoryId,
  }) async {
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) params['search'] = query;
    if (categoryId != null) params['category_id'] = categoryId;
    final response = await Api.dio.get(
      '/listings/search',
      queryParameters: params,
    );
    if (response.statusCode == 200) {
      final data = response.data['listings'] as List;
      return data.map((e) => ListingModel.fromJson(e)).toList();
    }
    throw Exception('Failed to search listings');
  }

  Future<List<ListingModel>> getFavorites() async {
    final response = await Api.dio.get('/favorites');
    if (response.statusCode == 200) {
      final data = response.data['listings'] as List;
      return data.map((e) => ListingModel.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch favorites');
  }

  Future<void> deleteImage(String url, int listingId) async {
    try {
      print(url);
      print(listingId);
      final response = await Api.dio.delete(
        '/deleteImage/$listingId',
        data: {'url': url},
      );

      print(response);

      if (response.statusCode == 200) {
        print('Image deleted successfully');
      } else {
        print('Failed to delete image from server');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> cancleRentaloption(int id) async {
    try {
      final response = await Api.dio.post('/cancel-rental-option/$id');

      print(response);

      if (response.statusCode == 200) {
        print('rental option cancled successfully');
      } else {
        print('Failed to cancle rental option');
      }
    } catch (e) {
      print('Error cancling rental option: $e');
    }
  }

  Future<void> editRentalOption(
    int id,
    double price,
    String unit,
    int duration,
  ) async {
    try {
      final response = await Api.dio.post(
        '/update-rental-options/$id',
        data: {'price': price, 'unit': unit, 'duration': duration},
      );

      print(response);

      if (response.statusCode == 200) {
        print('rental option edited successfully');
      } else {
        print('Failed to edit rental option');
      }
    } catch (e) {
      print('Error editing rental option: $e');
    }
  }

  Future<void> addRentalOption(
    int id,
    double price,
    String unit,
    int duration,
  ) async {
    try {
      final response = await Api.dio.post(
        '/add-rental-option',
        data: {
          'listing_id': id,
          'price': price,
          'unit': unit,
          'duration': duration,
        },
      );

      print(response);

      if (response.statusCode == 200) {
        print('rental option edited successfully');
      } else {
        print('Failed to edit rental option');
      }
    } catch (e) {
      print('Error editing rental option: $e');
    }
  }
}
