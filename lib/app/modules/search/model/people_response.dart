import 'package:social_app/app/data/user_model.dart';

class UsersResponse {
  List<UserModel> users;
  UsersResponse({required this.users});
  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    var usersJson = json['users'] as List;
    List<UserModel> usersList = usersJson
        .map((userJson) => UserModel.fromJson(userJson))
        .toList();
    return UsersResponse(users: usersList);
  }
}
