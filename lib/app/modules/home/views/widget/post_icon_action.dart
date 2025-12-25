import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class PostIconAction extends StatelessWidget {
  final IconData icon;
  const PostIconAction({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Icon(icon, size: 20, color: AppColors.iconColor),
      ),
    );
  }
}
