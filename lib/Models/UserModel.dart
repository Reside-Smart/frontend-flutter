class UserModel {
  final int id;
  String name;
  String email;
  String phoneNumber;
  String? image;
  String? address;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.image,
    this.address,
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
    };
  }

  @override
  String toString() {
    return 'UserModel{name: $name,phoneNumberL $phoneNumber , email: $email , image: $image, address: $address}';
  }
}
