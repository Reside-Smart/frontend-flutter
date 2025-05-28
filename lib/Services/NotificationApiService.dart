import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/NotificationModel.dart';
import 'package:reside_smart_flutter/Services/Api.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

class NotificationApiService extends GetxService {
  // Register FCM token with the server
  Future<bool> registerDeviceToken(String token) async {
    try {
      final response = await Api.dio.post(
        '/device/token',
        data: {
          'token': token,
          'device_type': GetPlatform.isAndroid ? 'android' : 'ios',
          'device_name':
              GetPlatform.isAndroid ? 'Android Device' : 'iOS Device',
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error registering device token: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error registering device token: $e');
      return false;
    }
  }

  // Delete FCM token from server
  Future<bool> deleteDeviceToken(String token) async {
    try {
      final response = await Api.dio.delete(
        '/device/token',
        data: {'token': token},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error deleting device token: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error deleting device token: $e');
      return false;
    }
  }

  // Get notifications from the server
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await Api.dio.get('/notifications');

      if (response.statusCode == 200) {
        List data = response.data['notifications'];
        return data
            .map(
              (item) => NotificationModel.fromJson({
                'id': item['id'],
                ...item['data'],
                'read': item['read_at'] != null,
                'related_id': item['data']['data']['related_id'] ?? 0,
              }),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching notifications: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error fetching notifications: $e');
      return [];
    }
  }

  // Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final response = await Api.dio.post(
        '/notifications/$notificationId/read',
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error marking notification as read: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error marking notification as read: $e');
      return false;
    }
  }

  // Mark all notifications as read
  Future<bool> markAllNotificationsAsRead() async {
    try {
      final response = await Api.dio.post('/notifications/read-all');

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error marking all notifications as read: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error marking all notifications as read: $e');
      return false;
    }
  }

  // Get notification settings
  Future<MyNotificationSettings> getNotificationSettings() async {
    try {
      final response = await Api.dio.get('/notifications/settings');

      if (response.statusCode == 200) {
        return MyNotificationSettings.fromJson(response.data['settings']);
      }
      return MyNotificationSettings(
        transactions: true,
        newListings: true,
        messages: true,
        discounts: true,
        reviews: true,
      );
    } on DioException catch (e) {
      print('Error fetching notification settings: ${e.message}');
      return MyNotificationSettings(
        transactions: true,
        newListings: true,
        messages: true,
        discounts: true,
        reviews: true,
      );
    } catch (e) {
      print('Unexpected error fetching notification settings: $e');
      return MyNotificationSettings(
        transactions: true,
        newListings: true,
        messages: true,
        discounts: true,
        reviews: true,
      );
    }
  }

  // Update notification settings
  Future<bool> updateNotificationSettings(
    MyNotificationSettings settings,
  ) async {
    try {
      final response = await Api.dio.post(
        '/notifications/settings',
        data: settings.toJson(),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error updating notification settings: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error updating notification settings: $e');
      return false;
    }
  }
}
