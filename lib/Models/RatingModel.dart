class RatingModel {
  final int? id;
  double? rating;
  final int? userId;
  final int? listingId;

  RatingModel({this.id, this.rating, this.userId, this.listingId});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rating: (json['rating'] as num).toDouble(),

      userId: json['user_id'],
      listingId: json['listing_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'user_id': userId,
      'listing_id': listingId,
    };
  }

  @override
  String toString() {
    return 'ListingModel{rating: $rating,userId: $userId, listingId:$listingId }';
  }
}
