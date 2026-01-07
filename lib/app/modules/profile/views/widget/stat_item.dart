import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/routes/app_pages.dart';
import 'package:social_app/app/services/auth_services.dart';

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
        InkWell(
          onTap: () async {
            final authService = Get.find<AuthServices>();
            await authService.logout();
            Get.offAllNamed(Routes.LOGIN);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.redAccent, size: 22),
                SizedBox(width: 10),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatsRow extends GetView<HomeController> {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Obx(() {
        final posts = controller.posts
            .where((p) => p.user.id == controller.authService.user.value?.id)
            .toList();
        return StatItem(label: "Posts", value: posts.length.toString());
      }),
    );
  }
}
