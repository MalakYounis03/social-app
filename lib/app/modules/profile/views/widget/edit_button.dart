import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/profile/controllers/profile_controller.dart';

class EditButton extends GetView<ProfileController> {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        onPressed: controller.editProfile,
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text("Edit Profile"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
