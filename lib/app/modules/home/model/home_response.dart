import 'package:social_app/app/data/posts_model.dart';

class HomeResponse {
  List<PostModel> posts;
  HomeResponse({required this.posts});
  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    var postsJson = json['posts'] as List;
    List<PostModel> postsList = postsJson
        .map((postJson) => PostModel.fromJson(postJson))
        .toList();
    return HomeResponse(posts: postsList);
  }
}
