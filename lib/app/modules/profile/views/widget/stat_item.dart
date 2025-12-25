import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_app/app/modules/profile/views/widget/edit_button.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  const StatItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: AppColors.hintText, fontSize: 12),
            ),
          ],
        ),
        EditButton(),
      ],
    );
  }
}

class StatsRow extends GetView<ProfileController> {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.fillColor.withOpacity(0.40),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Obx(
        () => StatItem(
          label: "Posts",
          value: controller.postsCount.value.toString(),
        ),
      ),
    );
  }
}
