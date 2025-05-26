import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Services/Api.dart';

class AnalyticsService extends GetxService {
  Future<Map<String, dynamic>> fetchAnalytics() async {
    try {
      final response = await Api.dio.get(
        '/dashboard-analytics',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer ${GetStorage().read('token')}',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // RETURN THE RAW JSON MAP DIRECTLY
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to fetch analytics');
      }
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
