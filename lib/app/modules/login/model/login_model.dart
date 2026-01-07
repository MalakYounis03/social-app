import 'package:social_app/app/data/user_model.dart';

class LoginModel {
  final UserModel user;
  final String token;
  LoginModel({required this.user, required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    print(json);

    return LoginModel(
      user: UserModel.fromJson(json['user']),
      token: json['access_token'],
    );
  }
}
