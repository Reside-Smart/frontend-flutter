class UserModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phoneNumber': phoneNumber};
  }

  @override
  String toString() {
    return 'UserModel{name: $name,phoneNumberL $phoneNumber , email: $email}';
  }
}
