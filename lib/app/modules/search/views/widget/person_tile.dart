import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class PersonTile extends StatelessWidget {
  final String name;
  const PersonTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fillColor.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  "@${name.toLowerCase().replaceAll(' ', '')}",
                  style: TextStyle(color: AppColors.hintText, fontSize: 12),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withOpacity(0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Follow"),
          ),
        ],
      ),
    );
  }
}
