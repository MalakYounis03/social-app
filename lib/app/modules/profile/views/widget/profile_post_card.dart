import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/home/views/widget/post_icon_action.dart';

class ProfilePostCard extends StatelessWidget {
  final String name;
  final String time;
  final String text;

  const ProfilePostCard({
    super.key,
    required this.name,
    required this.time,
    required this.text,
  });

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
              const CircleAvatar(radius: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: AppColors.hintText),
              ),
              const SizedBox(width: 6),
              Icon(Icons.more_vert),
            ],
          ),

          const SizedBox(height: 10),

          // Content
          Text(text, style: const TextStyle(height: 1.4, fontSize: 14)),

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
