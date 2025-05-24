class UserModel {
  final int id;
  String name;
  String email;
  String phoneNumber;
  String? image;
  String? address;
  double? latitude;
  double? longitude;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.image,
    this.address,
    this.latitude,
    this.longitude,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      image: json['image']?.toString(),
      address: json['address']?.toString(),
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'image': image,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'UserModel{name: $name, phoneNumber: $phoneNumber, email: $email, image: $image, address: $address, latitude: $latitude, longitude: $longitude}';
  }
}
