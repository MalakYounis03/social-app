import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/data/posts_model.dart';

class PostMiniCard extends StatelessWidget {
  final PostModel text;
  const PostMiniCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
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
                const CircleAvatar(radius: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text.user.name,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  text.createdAt.day.toString(),
                  style: TextStyle(color: AppColors.hintText, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
