// lib/presentation/themes/text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextStyles {
  // Headings - Light Theme
  static const TextStyle h1Light = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    fontFamily: 'Roboto',
  );

  static const TextStyle h2Light = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryLight,
    fontFamily: 'Roboto',
  );

  static const TextStyle h3Light = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
    fontFamily: 'Roboto',
  );

  // Headings - Dark Theme
  static const TextStyle h1Dark = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    fontFamily: 'Roboto',
  );

  static const TextStyle h2Dark = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
    fontFamily: 'Roboto',
  );

  static const TextStyle h3Dark = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryDark,
    fontFamily: 'Roboto',
  );

  // Body Text - Light Theme
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryLight,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryLight,
    fontFamily: 'Roboto',
  );

  // Body Text - Dark Theme
  static const TextStyle bodyLargeDark = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryDark,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyMediumDark = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryDark,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodySmallDark = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark,
    fontFamily: 'Roboto',
  );

  // Button Text
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
  );

  // Input Text
  static const TextStyle inputText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );
}
