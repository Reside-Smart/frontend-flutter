import 'package:reside_smart_flutter/Models/RatingModel.dart';
import 'package:reside_smart_flutter/Models/ReviewModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:dio/dio.dart' as dio;
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class ReviewsService {
  Future<void> addReview({required String text, required int listingId}) async {
    try {
      final response = await Api.dio.post(
        '/reviews',
        data: {'text': text, 'listing_id': listingId},
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

  Future<void> addRating({
    required double rating,
    required int listingId,
  }) async {
    try {
      final response = await Api.dio.post(
        '/ratings',
        data: {'rating': rating, 'listing_id': listingId},
      );
      print('response: ${response.data}');
    } on dio.DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Something went wrong';
      AppDialog.showError(errorMessage);
    } catch (e) {
      AppDialog.showError('Unexpected error: $e');
    }
  }

  Future<double?> fetchRating(int listingId) async {
    try {
      final response = await Api.dio.get('/show-ratings/$listingId');
      return response.data['rating'] != null
          ? (response.data['rating'] as num).toDouble()
          : null;
    } catch (e) {
      print('Error fetching rating: $e');
      return null;
    }
  }

  Future<List<String>> fetchUserReviews(int listingId) async {
    try {
      final response = await Api.dio.get('/user-reviews/$listingId');

      List<dynamic> data = response.data['data'];
      return data.map<String>((review) => review['text'].toString()).toList();
    } catch (e) {
      print('Error fetching user reviews: $e');
      return [];
    }
  }

  // Future<List<String>> fetchAllReviews(int listingId) async {
  //   final response = await Api.dio.get('/get-reviews/$listingId');

  //   if (response.statusCode == 200 && response.data['status'] == true) {
  //     List reviews = response.data['reviews'];
  //     return reviews.map<String>((r) => r['text'] as String).toList();
  //   } else {
  //     throw Exception('Failed to fetch reviews');
  //   }
  // }
  Future<List<ReviewModel>> fetchAllReviews(int listingId) async {
    final response = await Api.dio.get('/get-reviews/$listingId');

    if (response.statusCode == 200 && response.data['status'] == true) {
      List data = response.data['reviews'];
      return data.map((json) => ReviewModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<List<RatingModel>> fetchAllRatings(int listingId) async {
    try {
      final response = await Api.dio.get('/show-all-ratings/$listingId');

      if (response.statusCode == 200 && response.data['ratings'] != null) {
        return (response.data['ratings'] as List)
            .map((json) => RatingModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching ratings: $e');
      return [];
    }
  }
}
