import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/end_points.dart';
import 'package:social_app/app/data/posts_model.dart';
import 'package:social_app/app/data/user_model.dart';
import 'package:social_app/app/modules/home/model/home_response.dart';
import 'package:social_app/app/modules/search/model/people_response.dart';
import 'package:social_app/app/services/api_services.dart';

class SearchGetxController extends GetxController {
  final textController = TextEditingController();

  final query = ''.obs;
  final tabIndex = 0.obs;
  final isLoading = false.obs;
  final apiServices = Get.find<ApiServices>();

  final people = <UserModel>[].obs;
  final posts = <PostModel>[].obs;

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

  Future<void> fetchPeople() async {
    isLoading.value = true;

    try {
      final response = await apiServices.get(
        endPoint: EndPoints.getUsers,
        fromJson: UsersResponse.fromJson,
      );
      people.value = response.users;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load people: $e');
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchPosts();
    fetchPeople();
    textController.addListener(onChanged);
    super.onInit();
  }

  void onChanged() {
    query.value = textController.text.trim();
  }

  void clear() {
    textController.clear();
    query.value = '';
  }

  void setTab(int i) => tabIndex.value = i;

  List<UserModel> get filteredPeople {
    if (query.value.isEmpty) return [];
    final q = query.value.toLowerCase();
    return people.where((person) {
      return person.name.toLowerCase().contains(q);
    }).toList();
  }

  List<PostModel> get filteredPosts {
    if (query.value.isEmpty) return [];
    final q = query.value.toLowerCase();
    return posts.where((post) {
      return post.content.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onClose() {
    textController.removeListener(onChanged);
    textController.dispose();
    super.onClose();
  }
}
