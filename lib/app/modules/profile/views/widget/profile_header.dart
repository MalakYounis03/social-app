import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_app/app/modules/profile/views/widget/stat_item.dart';

class ProfileHeader extends GetView<ProfileController> {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
          const CircleAvatar(radius: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.name.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.username.value,
                    style: TextStyle(color: AppColors.hintText),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.bio.value,
                    style: const TextStyle(height: 1.35),
                  ),
                  SizedBox(height: 20),
                  StatsRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
