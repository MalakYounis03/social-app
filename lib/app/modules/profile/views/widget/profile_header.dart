import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/modules/profile/views/widget/stat_item.dart';
import 'package:social_app/app/services/auth_services.dart';

class ProfileHeader extends GetView<HomeController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthServices>();

    final savedUser = authService.user.value;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundImage: NetworkImage(savedUser!.imageUrl),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  savedUser.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  savedUser.email,
                  style: TextStyle(color: AppColors.hintText),
                ),
                const SizedBox(height: 8),
                Text(
                  "This is my bio! I love coding and sharing my projects with the world.",
                  style: TextStyle(color: AppColors.hintText, height: 1.4),
                ),
                SizedBox(height: 20),
                StatsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
