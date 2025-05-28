class NotificationModel {
  final String? id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String createdAt;
  final bool read;
  final int relatedId;

  NotificationModel({
    this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    required this.read,
    required this.relatedId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(),
      type: json['type'] ?? 'general',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'] ?? {},
      createdAt: json['created_at'] ?? '',
      read: json['read'] ?? false,
      relatedId: json['related_id'] ?? 0,
    );
  }

  // Get route based on notification type
  String get route {
    switch (type) {
      case 'transaction':
        return '/view-single-transactions';
      case 'new_listing':
      case 'listing':
        return '/view-Single-listing';
      case 'chat':
      case 'message':
        return '/chat';
      case 'discount':
        return '/view-single-listing';
      case 'review':
        return '/view-review';
      default:
        return '/notifications';
    }
  }

  // Get arguments for navigation based on notification type
  Map<String, dynamic> get arguments {
    switch (type) {
      case 'transaction':
        return {'id': relatedId};
      case 'new_listing':
      case 'listing':
        return {'id': relatedId};
      case 'chat':
        return {'userId': data['sender_id']};
      case 'discount':
        return {'id': relatedId};
      case 'review':
        return {'listingId': relatedId};
      default:
        return {};
    }
  }
}

class MyNotificationSettings {
  final bool transactions;
  final bool newListings;
  final bool messages;
  final bool discounts;
  final bool reviews;

  MyNotificationSettings({
    required this.transactions,
    required this.newListings,
    required this.messages,
    required this.discounts,
    required this.reviews,
  });

  factory MyNotificationSettings.fromJson(Map<String, dynamic> json) {
    return MyNotificationSettings(
      transactions: json['transactions'] ?? true,
      newListings: json['new_listings'] ?? true,
      messages: json['messages'] ?? true,
      discounts: json['discounts'] ?? true,
      reviews: json['reviews'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions,
      'new_listings': newListings,
      'messages': messages,
      'discounts': discounts,
      'reviews': reviews,
    };
  }
}
