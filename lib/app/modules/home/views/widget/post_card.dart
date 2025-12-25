import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/home/views/widget/post_icon_action.dart';

class PostCard extends StatelessWidget {
  final int index;
  const PostCard({super.key, required this.index});

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
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/chats.png'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "User $index",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                "2:30 PM",
                style: TextStyle(fontSize: 12, color: AppColors.hintText),
              ),
              const SizedBox(width: 6),
              Icon(Icons.more_vert),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Hello! This is a post from user $index. 🔥\n"
            "هنا نص منشور بسيط لعرض الستايل.",
            style: const TextStyle(height: 1.4, fontSize: 14),
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 6),

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
