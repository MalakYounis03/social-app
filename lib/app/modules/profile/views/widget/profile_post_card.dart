import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/constants/formate_post_time.dart';
import 'package:social_app/app/data/posts_model.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/home/views/widget/post_icon_action.dart';

class ProfilePostCard extends GetView<HomeController> {
  final PostModel post;

  const ProfilePostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: post.user.imageUrl.isNotEmpty
                    ? NetworkImage(post.user.imageUrl)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  post.user.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                formatPostTime(post.createdAt),
                style: TextStyle(fontSize: 12, color: AppColors.hintText),
              ),
              const SizedBox(width: 6),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete') {
                    controller.deletePost(post.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Content
          Text(post.content, style: const TextStyle(height: 1.4, fontSize: 14)),

          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 6),

          // Actions (اختياري — إذا بدك نفس الـ Home)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              PostIconAction(icon: Icons.favorite_border),
              PostIconAction(icon: Icons.chat_bubble_outline),
              PostIconAction(icon: Icons.share_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
