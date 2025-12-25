import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_app/app/modules/profile/views/widget/profile_post_card.dart';

class PostsList extends GetView<ProfileController> {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = controller.myPosts;

      if (posts.isEmpty) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Icon(Icons.article_outlined, size: 42, color: AppColors.hintText),
              const SizedBox(height: 10),
              Text("No posts yet", style: TextStyle(color: AppColors.hintText)),
              const SizedBox(height: 24),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => ProfilePostCard(
          name: controller.name.value,
          time: "2h", // TODO: اربطها بوقت حقيقي
          text: posts[i],
        ),
      );
    });
  }
}
