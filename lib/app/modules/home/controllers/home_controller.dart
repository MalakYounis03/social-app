import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/data/posts_model.dart';
import 'package:social_app/app/modules/home/model/add_post_response.dart';
import 'package:social_app/app/modules/home/model/delete_post_response.dart';
import 'package:social_app/app/modules/home/model/home_response.dart';
import 'package:social_app/app/services/api_services.dart';
import 'package:social_app/app/services/auth_services.dart';

class HomeController extends GetxController {
  final textController = TextEditingController();
  RxBool canPost = false.obs;
  RxBool isLoading = false.obs;
  RxList<PostModel> posts = <PostModel>[].obs;
  final apiServices = Get.find<ApiServices>();
  final authService = Get.find<AuthServices>();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    fetchPosts();
    textController.addListener(onTextChanged);
    super.onInit();
  }

  void onTextChanged() {
    canPost.value = textController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    super.dispose();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;

    try {
      final response = await apiServices.get(
        endPoint: EndPoints.getPosts,
        fromJson: HomeResponse.fromJson,
      );
      posts.value = response.posts;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load posts: $e');
    }
    isLoading.value = false;
  }

  Future<void> addPost() async {
    final content = textController.text.trim();

    if (content.isEmpty) {
      Get.snackbar('Error', 'Post content cannot be empty');
      return;
    }
    try {
      final response = await apiServices.post(
        endPoint: EndPoints.addPost,
        body: {'content': content},
        fromJson: AddPostResponse.fromJson,
      );

      posts.insert(0, response.post);
      posts.refresh();

      textController.clear();

      Get.back();

      Get.snackbar('Success', 'Post added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await apiServices.delete(
        endPoint: EndPoints.deletePost,
        postId: postId,
        fromJson: DeletePostResponse.fromJson,
      );

      posts.removeWhere((post) => post.id == postId);
      posts.refresh();

      Get.snackbar('Success', 'Post deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post: $e');
    }
  }

  bool isMyPost(PostModel post) {
    return post.user.id == authService.user.value?.id;
  }
}
