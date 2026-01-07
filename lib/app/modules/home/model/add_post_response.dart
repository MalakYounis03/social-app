import 'package:social_app/app/data/posts_model.dart';

class AddPostResponse {
  final PostModel post;
  AddPostResponse({required this.post});
  factory AddPostResponse.fromJson(Map<String, dynamic> json) {
    return AddPostResponse(post: PostModel.fromJson(json['post']));
  }
}
