import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/modules/home/views/widget/create_post_card.dart';
import 'package:social_app/app/modules/home/views/widget/post_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: controller.fetchPosts,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),

                    itemCount: controller.posts.length + 2,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      if (index == 0) return CreatePostCard();
                      if (index == 1) return const SizedBox(height: 14);

                      final postIndex = index - 2;
                      return PostCard(post: controller.posts[postIndex]);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
