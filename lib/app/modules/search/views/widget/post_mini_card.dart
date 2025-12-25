import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class PostMiniCard extends StatelessWidget {
  final String text;
  const PostMiniCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.fillColor.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "User",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  "1h",
                  style: TextStyle(color: AppColors.hintText, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              text,
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
