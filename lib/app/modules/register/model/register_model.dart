import 'package:social_app/app/data/user_model.dart';

class RegisterModel {
  final String token;
  final UserModel user;

  RegisterModel({required this.token, required this.user});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      token: json['access_token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
