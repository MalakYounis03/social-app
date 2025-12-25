import 'package:flutter/material.dart';

class AppColors {
  static Color background = Color(0xFF0B1220);
  static Color primary = Color(0xFF4C8DFF);
  static Color disabledBackgroundColor = primary.withOpacity(0.35);
  static Color disabledForegroundColor = Colors.white.withOpacity(0.75);
  static Color primaryBorder = primary.withOpacity(0.6);
  static Color buttonSellected = AppColors.primary.withOpacity(0.25);
  static Color hintText = Color(0xFF6E7FA6);
  static Color iconColor = Color(0xFF93A4C7);
  static Color border = Color(0xFF1E2A44).withOpacity(0.6);
  static Color fillColor = Colors.grey.shade900..withOpacity(0.35);
}
