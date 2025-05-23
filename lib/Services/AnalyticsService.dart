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
// import 'dart:convert';
// import 'package:dio/dio.dart' as dio;
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:reside_smart_flutter/Services/Api.dart';
// import 'AuthService.dart';

// class AnalyticsService extends GetxService {
//   late final String _token;

//   @override
//   void onInit() {
//     // _token = Get.find<AuthService>().globalUser!.token!;
//     super.onInit();
//   }

//   Future<Map<String, dynamic>> fetchAnalytics() async {
//     final response = await Api.dio.get('/dashboard-analytics');
//     if (response.statusCode == 200) {
//       return json.decode(response.data);
//     }
//     throw Exception('Failed to load analytics');
//   }

//   Future<List<dynamic>> fetchReservations() async {
//     final response = await Api.dio.get('/reservations');
//     if (response.statusCode == 200) {
//       return json.decode(response.data)['reserved_ranges'];
//     }
//     throw Exception('Failed to load reservations');
//   }
// }
