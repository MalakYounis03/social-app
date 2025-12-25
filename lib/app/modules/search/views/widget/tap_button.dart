import 'package:flutter/material.dart';
import 'package:social_app/app/constants/app_colors.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const TabButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? AppColors.buttonSellected : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.hintText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
