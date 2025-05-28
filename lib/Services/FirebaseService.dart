import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reside_smart_flutter/Models/NotificationModel.dart';
import 'package:reside_smart_flutter/Services/NotificationApiService.dart';
import 'package:reside_smart_flutter/Utils/Dialog.dart';

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class FirebaseService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationApiService _notificationApiService =
      Get.find<NotificationApiService>();

  // State variables
  final RxInt unreadCount = 0.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final Rx<MyNotificationSettings> settings =
      MyNotificationSettings(
        transactions: true,
        newListings: true,
        messages: true,
        discounts: true,
        reviews: true,
      ).obs;

  // Single notification channel
  final String _notificationChannelId = 'high_importance_channel';

  // Initialize Firebase
  Future<void> init() async {
    print('Call FIREBASE SERVICE AND init background message');
    await checkNotificationStatus();

    // background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize notifications
    await _initializeNotifications();

    // Request permission
    await _requestPermission();

    // Set up foreground message handler
    _setupForegroundMessageHandler();

    // Set up message opened handler
    _setupMessageOpenedHandler();

    // Check for initial message
    _checkInitialMessage();

    // Get and store FCM token
    await _getFcmToken();

    // Load notifications
    await fetchNotifications();

    // Load settings
    await fetchNotificationSettings();
  }

  // Initialize local notifications
  Future<void> _initializeNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    // Initialize settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(json.decode(response.payload ?? '{}'));
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  // Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    final androidPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin == null) return;

    // Create a single channel for all notifications
    final channel = AndroidNotificationChannel(
      _notificationChannelId,
      'Notifications',
      description: 'This channel is used for all app notifications',
      importance: Importance.high,
    );

    await androidPlugin.createNotificationChannel(channel);
    print("Notification channel created: ${channel.id}");
  }

  // Request permission for notifications
  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    }
  }

  // Set up foreground message handler
  void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 FOREGROUND MESSAGE RECEIVED:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Data: ${message.data}");
      // Show notification
      _showNotification(message);

      // Refresh notifications list
      fetchNotifications();
    });
  }

  // Set up message opened handler
  void _setupMessageOpenedHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A notification was tapped while app was in the background!');

      // Handle notification tap
      _handleNotificationTap(message.data);

      AppDialog.showSuccess(message.toString());
      // Refresh notifications list
      fetchNotifications();
    });
  }

  // Check for initial message
  void _checkInitialMessage() async {
    // Check if the app was opened from a notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      print('App opened from terminated state via notification!');

      // Handle notification tap
      _handleNotificationTap(initialMessage.data);

      // Refresh notifications list
      fetchNotifications();
    }
  }

  // Get FCM token and register with server
  Future<void> _getFcmToken() async {
    try {
      String? token = await _messaging.getToken();

      if (token != null) {
        print('FCM Token: $token');

        // Store token locally
        await GetStorage().write('fcm_token', token);

        // Send token to server if user is logged in
        if (Get.find<GetStorage>().hasData('login_token')) {
          await _notificationApiService.registerDeviceToken(token);
        }
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((String token) {
        print('FCM Token refreshed: $token');

        // Store refreshed token locally
        GetStorage().write('fcm_token', token);

        // Send refreshed token to server if user is logged in
        if (Get.find<GetStorage>().hasData('login_token')) {
          _notificationApiService.registerDeviceToken(token);
        }
      });
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  // Show notification
  Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Only show notification if there is a notification payload
    if (notification != null) {
      try {
        // Show notification using the single channel
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _notificationChannelId,
              'Notifications',
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: json.encode(message.data),
        );
        print("Notification displayed successfully");
      } catch (e) {
        print("Error showing notification: $e");
      }
    }
  }

  // Handle notification tap
  void _handleNotificationTap(Map<String, dynamic> data) {
    try {
      print("Handling notification tap with data: $data");
      // Create a notification model from data
      NotificationModel notification = NotificationModel.fromJson({
        'id': data['id'],
        'type': data['data']['type'] ?? 'general',
        'title': data['data']['title'] ?? 'Notification',
        'body': data['data']['body'] ?? 'You have a new notification',
        'data': data['data']['data'] ?? {},
        'created_at': data['created_at'] ?? DateTime.now().toIso8601String(),
        'read': data['read_at'] != null,
        'related_id': data['data']['data']['related_id'] ?? 0,
      });

      // Navigate to appropriate screen
      Get.toNamed(notification.route, arguments: notification.arguments);

      // Mark notification as read if it has an ID
      if (data['id'] != null) {
        _notificationApiService.markNotificationAsRead(data['id']);
      }
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  // Fetch notifications from server
  Future<void> fetchNotifications() async {
    try {
      final List<NotificationModel> fetchedNotifications =
          await _notificationApiService.getNotifications();

      notifications.value = fetchedNotifications;

      // Update unread count
      unreadCount.value = notifications.where((n) => !n.read).length;
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final success = await _notificationApiService.markNotificationAsRead(
        notificationId,
      );

      if (success) {
        // Update local notification
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final updatedNotification = NotificationModel(
            id: notifications[index].id,
            type: notifications[index].type,
            title: notifications[index].title,
            body: notifications[index].body,
            data: notifications[index].data,
            createdAt: notifications[index].createdAt,
            read: true,
            relatedId: notifications[index].relatedId,
          );

          notifications[index] = updatedNotification;
          notifications.refresh();

          // Update unread count
          unreadCount.value = notifications.where((n) => !n.read).length;
        }
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final success =
          await _notificationApiService.markAllNotificationsAsRead();

      if (success) {
        // Update all local notifications
        notifications.value =
            notifications
                .map(
                  (notification) => NotificationModel(
                    id: notification.id,
                    type: notification.type,
                    title: notification.title,
                    body: notification.body,
                    data: notification.data,
                    createdAt: notification.createdAt,
                    read: true,
                    relatedId: notification.relatedId,
                  ),
                )
                .toList();

        notifications.refresh();

        // Update unread count
        unreadCount.value = 0;
      }
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  // Fetch notification settings
  Future<void> fetchNotificationSettings() async {
    try {
      final MyNotificationSettings fetchedSettings =
          await _notificationApiService.getNotificationSettings();

      settings.value = fetchedSettings;
    } catch (e) {
      print('Error fetching notification settings: $e');
    }
  }

  // Update notification settings
  Future<void> updateNotificationSettings(
    MyNotificationSettings newSettings,
  ) async {
    try {
      final success = await _notificationApiService.updateNotificationSettings(
        newSettings,
      );

      if (success) {
        settings.value = newSettings;
        AppDialog.showSuccess('Notification settings updated successfully.');
      } else {
        AppDialog.showError('Failed to update notification settings.');
      }
    } catch (e) {
      print('Error updating notification settings: $e');
      AppDialog.showError(
        'An error occurred while updating notification settings.',
      );
    }
  }

  // Register device token with server (call this after login)
  Future<void> registerDeviceToken() async {
    try {
      final String? token = GetStorage().read('fcm_token');

      if (token != null) {
        await _notificationApiService.registerDeviceToken(token);
      } else {
        // If token is not found, get a new one
        final String? newToken = await _messaging.getToken();

        if (newToken != null) {
          await GetStorage().write('fcm_token', newToken);
          await _notificationApiService.registerDeviceToken(newToken);
        }
      }
    } catch (e) {
      print('Error registering device token: $e');
    }
  }

  // Unregister device token from server (call this during logout)
  Future<void> unregisterDeviceToken() async {
    try {
      final String? token = await GetStorage().read('fcm_token');

      if (token != null) {
        await _notificationApiService.deleteDeviceToken(token);
      }
    } catch (e) {
      print('Error unregistering device token: $e');
    }
  }

  // Add to FirebaseService
  Future<void> checkNotificationStatus() async {
    print("=================== FCM STATUS CHECK ===================");
    print("FCM Token: ${await _messaging.getToken()}");

    final settings = await _messaging.getNotificationSettings();
    print("Authorization Status: ${settings.authorizationStatus}");
    print("Alert Setting: ${settings.alert}");
    print("Badge Setting: ${settings.badge}");
    print("Sound Setting: ${settings.sound}");

    print(
      "Android Notification Channel: ${await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.getNotificationChannels()}",
    );
    print("=======================================================");
  }
}
