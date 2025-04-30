class RentalOption {
  final int? id;
  final int? listingId;
  final int duration;
  final String unit;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RentalOption({
    this.id,
    this.listingId,
    required this.duration,
    required this.unit,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory RentalOption.fromJson(Map<String, dynamic> json) {
    return RentalOption(
      id: json['id'] as int?,
      listingId: json['listing_id'] as int?,
      duration: json['duration'] as int,
      unit: json['unit'] as String,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listing_id': listingId,
      'duration': duration,
      'unit': unit,
      'price': price,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
