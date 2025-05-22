import 'package:reside_smart_flutter/Models/UserModel.dart';

class ReviewModel {
  final int? id;
  String? text;
  final int? userId;
  final int? listingId;
  final String? createdAt;
  final UserModel? user;

  ReviewModel({
    this.id,
    this.text,
    this.userId,
    this.listingId,
    this.createdAt,
    this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      text: json['text'],
      userId: json['user_id'],
      listingId: json['listing_id'],
      createdAt: json['created_at'],
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'user_id': userId,
      'created_at': createdAt,
      'listing_id': listingId,
    };
  }

  @override
  String toString() {
    return 'ListingModel{text: $text,userId: $userId, listingId:$listingId , createdAt: $createdAt}';
  }
}
