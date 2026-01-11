import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/home/controllers/home_controller.dart';
import 'package:social_app/app/services/auth_services.dart';

class CreatePostCard extends GetView<HomeController> {
  const CreatePostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthServices>();

    final savedUser = authService.user.value;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(savedUser!.imageUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Form(
                  key: controller.formKey,
                  child: TextFormField(
                    controller: controller.textController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Post content cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(color: AppColors.hintText),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),

          Obx(() {
            final isDisabled =
                !controller.canPost.value || controller.isPosting.value;

            return Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: isDisabled
                    ? null
                    : () async {
                        await controller.addPost();
                      },
                icon: controller.isPosting.value
                    ? null
                    : Icon(Icons.send, size: 18),
                label: Text(controller.isPosting.value ? 'Posting...' : 'Post'),

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.disabledBackgroundColor,
                  disabledForegroundColor: AppColors.disabledForegroundColor,
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
            );
          }),
        ],
      ),
    );
  }
}
