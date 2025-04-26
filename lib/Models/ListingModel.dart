class ListingModel {
  final int? id;
  String? name;
  String? type;
  String? categoryId;
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
  List<Map<String, dynamic>>? rentalOption;

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
    this.rentalOption,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      categoryId: json['category'],
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
      rentalOption:
          json['rental_options'] != null
              ? List<Map<String, dynamic>>.from(json['rental_options'])
              : null,
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
      'renting_option': rentalOption,
    };
  }

  @override
  String toString() {
    return 'ListingModel{name: $name, type: $type, category: $categoryId, address: $address, price: $price, images: $images, features: $features, description: $description, userId: $userId}';
  }
}
