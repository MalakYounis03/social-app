import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class EmptyState extends StatelessWidget {
  final String text;
  const EmptyState({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 40, color: AppColors.hintText),
          const SizedBox(height: 10),
          Text(text, style: TextStyle(color: AppColors.hintText)),
        ],
      ),
    );
  }
}
