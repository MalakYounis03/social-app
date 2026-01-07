import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/modules/login/controllers/login_controller.dart';

class CustomTextFiled extends GetView<LoginController> {
  final String hintText;
  final IconData icon;
  final TextEditingController? textEditingController;

  const CustomTextFiled({
    super.key,
    required this.hintText,
    required this.icon,
    required this.textEditingController,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Form(
        child: TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.hintText),
            icon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
