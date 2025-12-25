import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class CustomTextFiled extends StatelessWidget {
  final String hintText;
  final IconData icon;

  const CustomTextFiled({
    super.key,
    required this.hintText,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Form(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.hintText),
            icon: Icon(icon),
            iconColor: AppColors.iconColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: AppColors.fillColor,
          ),
        ),
      ),
    );
  }
}
