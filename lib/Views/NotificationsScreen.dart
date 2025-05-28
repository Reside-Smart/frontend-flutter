import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reside_smart_flutter/Models/NotificationModel.dart';
import 'package:reside_smart_flutter/Services/FirebaseService.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final DateFormat _dateFormat = DateFormat('MMM d, yyyy h:mm a');

  @override
  void initState() {
    super.initState();
    _firebaseService.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyMainAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.toNamed('/notifications/settings'),
          ),
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () => _markAllAsRead(),
          ),
        ],
      ),
      body: Obx(() {
        if (_firebaseService.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _firebaseService.fetchNotifications(),
          child: ListView.builder(
            itemCount: _firebaseService.notifications.length,
            itemBuilder: (context, index) {
              final notification = _firebaseService.notifications[index];
              return _buildNotificationTile(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildNotificationIcon(notification.type),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(notification.body),
          SizedBox(height: 4),
          Text(
            _dateFormat.format(DateTime.parse(notification.createdAt)),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      tileColor: notification.read ? null : Colors.blue.withOpacity(0.05),
      onTap: () {
        _firebaseService.markAsRead(notification.id!);
        Get.toNamed(notification.route, arguments: notification.arguments);
      },
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'transaction':
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'new_listing':
      case 'listing':
        iconData = Icons.home;
        iconColor = Colors.blue;
        break;
      case 'chat':
      case 'message':
        iconData = Icons.chat;
        iconColor = Colors.purple;
        break;
      case 'discount':
        iconData = Icons.local_offer;
        iconColor = Colors.orange;
        break;
      case 'review':
        iconData = Icons.star;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  void _markAllAsRead() {
    _firebaseService.markAllAsRead();
  }
}
