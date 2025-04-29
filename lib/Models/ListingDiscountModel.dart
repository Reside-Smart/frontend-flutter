import 'package:reside_smart_flutter/Models/ListingModel.dart';

class ListingDiscountModel {
  final String name;
  final int listingId;
  final double percentage;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final ListingModel? listing;

  ListingDiscountModel({
    required this.name,
    required this.listingId,
    required this.percentage,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.listing,
  });

  factory ListingDiscountModel.fromJson(Map<String, dynamic> json) {
    return ListingDiscountModel(
      name: json['name'],
      listingId: json['listing_id'],
      percentage: double.parse(json['percentage']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      listing:
          json['listing'] == null
              ? null
              : ListingModel.fromJson(json['listing']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'listing_id': listingId,
      'percentage': percentage,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
    };
  }

  @override
  String toString() {
    return 'ListingDiscountModel{name: $name, listingId: $listingId, percentage: $percentage, startDate: $startDate, endDate: $endDate, status: $status}';
  }

  double getDiscountPrice() {
    if (listing == null) return 0;
    if (listing!.type == "sell") {
      return listing!.getPrice() * (1 - percentage / 100);
    }
    if (listing!.type == "rent") {
      return listing!.getPrice() * (1 - percentage / 100);
    }
    return 0;
  }
}
