class UserModel {
  String? phone;
  String? username;
  String? email;
  String? password;

  UserModel({this.phone, this.username, this.email, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
