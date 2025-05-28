import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reside_smart_flutter/Models/NotificationModel.dart';
import 'package:reside_smart_flutter/Services/FirebaseService.dart';
import 'package:reside_smart_flutter/Widgets/MyMainAppBar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  @override
  void initState() {
    super.initState();
    _firebaseService.fetchNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyMainAppBar(title: 'Notification Settings'),
      body: Obx(() {
        final settings = _firebaseService.settings.value;

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildSettingHeader('Receive notifications for:'),
            SwitchListTile(
              title: Text('Transactions'),
              subtitle: Text('Updates about your purchases and sales'),
              value: settings.transactions,
              onChanged:
                  (value) =>
                      _updateSettings(settings.copyWith(transactions: value)),
            ),
            Divider(),
            SwitchListTile(
              title: Text('New Listings'),
              subtitle: Text('When new properties are listed'),
              value: settings.newListings,
              onChanged:
                  (value) =>
                      _updateSettings(settings.copyWith(newListings: value)),
            ),
            Divider(),
            SwitchListTile(
              title: Text('Messages'),
              subtitle: Text('When you receive new messages'),
              value: settings.messages,
              onChanged:
                  (value) =>
                      _updateSettings(settings.copyWith(messages: value)),
            ),
            Divider(),
            SwitchListTile(
              title: Text('Discounts'),
              subtitle: Text('Special offers and promotions'),
              value: settings.discounts,
              onChanged:
                  (value) =>
                      _updateSettings(settings.copyWith(discounts: value)),
            ),
            Divider(),
            SwitchListTile(
              title: Text('Reviews'),
              subtitle: Text('When someone reviews your property'),
              value: settings.reviews,
              onChanged:
                  (value) => _updateSettings(settings.copyWith(reviews: value)),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSettingHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _updateSettings(MyNotificationSettings newSettings) {
    _firebaseService.updateNotificationSettings(newSettings);
  }
}

// Add this extension to make it easier to update settings
extension NotificationSettingsExtension on MyNotificationSettings {
  MyNotificationSettings copyWith({
    bool? transactions,
    bool? newListings,
    bool? messages,
    bool? discounts,
    bool? reviews,
  }) {
    return MyNotificationSettings(
      transactions: transactions ?? this.transactions,
      newListings: newListings ?? this.newListings,
      messages: messages ?? this.messages,
      discounts: discounts ?? this.discounts,
      reviews: reviews ?? this.reviews,
    );
  }
}
