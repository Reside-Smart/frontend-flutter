import 'package:reside_smart_flutter/Models/RentalOption.dart';
import 'package:reside_smart_flutter/Models/UserModel.dart';
import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';

class ListingModel {
  final int? id;
  String? name;
  String? type;
  int? categoryId;
  String? address;
  List<String>? images;
  double? price;
  List<Map<String, dynamic>>? features;
  String? description;
  String? status;
  bool? isAvailable;
  double? averageReviews;
  Map<String, dynamic>? location;
  final int? userId;
  final UserModel? user;
  List<RentalOption>? rentalOptions;
  bool isFavorite;
  List<ListingDiscountModel>? discounts;

  ListingModel({
    this.id,
    this.name,
    this.type,
    this.categoryId,
    this.address,
    this.images,
    this.price,
    this.features,
    this.description,
    this.status,
    this.isAvailable,
    this.averageReviews,
    this.location,
    this.userId,
    this.rentalOptions,
    this.isFavorite = false,
    this.user,
    this.discounts,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      categoryId: json['category_id'],
      address: json['address'],
      images: List<String>.from(json['images'] ?? []),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      features: List<Map<String, dynamic>>.from(json['features'] ?? []),
      description: json['description'],
      status: json['status'],
      isAvailable: json['is_available'] == 1,
      averageReviews:
          double.tryParse(json['average_reviews']?.toString() ?? '0.0') ?? 0.0,

      location: Map<String, dynamic>.from(json['location'] ?? {}),
      userId: json['user_id'],
      rentalOptions:
          json['rental_options'] != null
              ? (json['rental_options'] as List)
                  .map((e) => RentalOption.fromJson(e))
                  .toList()
              : [],
      isFavorite: json['is_favorite'] == null ? false : (json['is_favorite']),
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
      discounts:
          json['discounts'] != null
              ? (json['discounts'] as List)
                  .map((e) => ListingDiscountModel.fromJson(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'category_id': categoryId,
      'address': address,
      'images': images,
      'price': price,
      'features': features,
      'description': description,
      'status': status,
      'is_available': isAvailable != null ? (isAvailable! ? 1 : 0) : null,
      'average_reviews': averageReviews,
      'location': location,
      'user_id': userId,
      'renting_option': rentalOptions,
    };
  }

  @override
  String toString() {
    return 'ListingModel{name: $name, type: $type, category: $categoryId, address: $address, price: $price, images: $images, features: $features, description: $description, userId: $userId}';
  }

  double getPrice() {
    if (price == null) return 0;
    if (type == "sell") return price!;
    if (type == "rent")
      return rentalOptions!.isEmpty ? 0 : rentalOptions![0].price;
    return 0;
  }
}
