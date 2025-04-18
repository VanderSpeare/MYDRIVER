class User {
  final String phoneNumber;
  final String role;

  User({required this.phoneNumber, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phoneNumber: json['phoneNumber'],
      role: json['role'],
    );
  }
}