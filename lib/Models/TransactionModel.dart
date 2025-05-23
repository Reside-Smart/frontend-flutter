import 'package:reside_smart_flutter/Models/ListingDiscountModel.dart';
import 'package:reside_smart_flutter/Models/ListingModel.dart';

class TransactionModel {
  final int? id;
  String? type; // 'sell' or 'rent'
  double? totalPrice;
  double? amountPaid;
  String? paymentStatus; // 'unpaid' or 'paid'
  String? paymentMethod; // 'cash' or 'stripe'
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int? listingId;
  int? buyerId;
  int? sellerId;
  int? discountId;
  int? rentalOptionId;
  int? quantity; // Added quantity field
  ListingModel? listing;
  ListingDiscountModel? discount;

  TransactionModel({
    this.id,
    this.type,
    this.totalPrice,
    this.amountPaid,
    this.paymentStatus,
    this.paymentMethod,
    this.checkInDate,
    this.checkOutDate,
    this.listingId,
    this.buyerId,
    this.sellerId,
    this.discountId,
    this.rentalOptionId,
    this.quantity, // Added to constructor
    this.listing,
    this.discount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: json['transaction_type'],
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      amountPaid: double.tryParse(json['amount_paid'].toString()) ?? 0.0,
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      checkInDate:
          json['check_in_date'] != null
              ? DateTime.tryParse(json['check_in_date'])
              : null,
      checkOutDate:
          json['check_out_date'] != null
              ? DateTime.tryParse(json['check_out_date'])
              : null,
      listingId: json['listing_id'],
      buyerId: json['buyer_id'],
      sellerId: json['seller_id'],
      discountId: json['discount_id'],
      rentalOptionId: json['rental_option_id'],
      quantity:
          json['quantity'] != null
              ? int.tryParse(json['quantity'].toString())
              : 1, // Parse quantity with default

      listing:
          json['listing'] != null
              ? ListingModel.fromJson(json['listing'])
              : null,

      discount:
          json['listing_discount'] != null
              ? ListingDiscountModel.fromJson(json['listing_discount'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_type': type,
      'total_price': totalPrice,
      'amount_paid': amountPaid,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'check_in_date': checkInDate!.toIso8601String(),
      'check_out_date':
          checkOutDate != null ? checkOutDate!.toIso8601String() : null,
      'listing_id': listingId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'discount_id': discountId,
      'rental_option_id': rentalOptionId,
      'quantity': quantity, // Added to JSON serialization
      'listing': listing,
      'discount': discount,
    };
  }

  @override
  String toString() {
    return 'TransactionModel{id: $id, type: $type, amountPaid: $amountPaid, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, checkInDate: $checkInDate, checkOutDate: $checkOutDate, listingId: $listingId, buyerId: $buyerId, sellerId: $sellerId, discountId: $discountId, quantity: $quantity}';
  }
}
