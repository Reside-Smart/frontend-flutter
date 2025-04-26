import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart%20';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class ListingService extends GetxService {
  final _storage = GetStorage();

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
      String? token = _storage.read('token');

      final response = await Api.dio.get(
        '/user/listings',
        queryParameters:
            status != null ? {'status': status.toLowerCase()} : null,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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

  Future<void> UpdateAsDraft({
    required dio.FormData formData,
    required int id,
  }) async {
    print(formData.fields);
    print(formData.files);
    final response = await Api.dio.post(
      '/listings-update-draft/$id',
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    print(response);
  }
}
