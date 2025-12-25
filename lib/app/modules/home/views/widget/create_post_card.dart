import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';

class CreatePostCard extends GetView<HomeController> {
  const CreatePostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fillColor.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Obx(
        () => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controller.textController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(color: AppColors.hintText),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(height: 1, color: AppColors.border.withOpacity(0.6)),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: controller.canPost.value
                    ? controller.publish
                    : null, // ✅ disabled لما فاضي
                icon: const Icon(Icons.send, size: 18),
                label: const Text("Post"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.35),
                  disabledForegroundColor: Colors.white.withOpacity(0.75),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
