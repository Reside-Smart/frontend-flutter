// services/FavoriteService.dart
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Services/Api.dart';

class FavoriteService extends GetxService {
  /// Adds a favorite; returns true on success
  Future<bool> addFavorite(int listingId) async {
    final resp = await Api.dio.post(
      '/favorites',
      data: {'listing_id': listingId},
    );
    return resp.statusCode == 200;
  }

  /// Removes a favorite; returns true on success
  Future<bool> removeFavorite(int listingId) async {
    final resp = await Api.dio.delete('/favorites/$listingId');
    return resp.statusCode == 200;
  }
}
