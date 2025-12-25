import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class SearchHint extends StatelessWidget {
  const SearchHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 42, color: AppColors.hintText),
            const SizedBox(height: 10),
            Text(
              "Start typing to search people or posts",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.hintText),
            ),
          ],
        ),
      ),
    );
  }
}
