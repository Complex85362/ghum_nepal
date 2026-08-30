import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: AppColors.textOnPrimary,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static TextStyle get displayLargeMobile => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textOnPrimary,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static TextStyle get heading1 => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static TextStyle get heading2 => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle get heading3 => GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get subtitle => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get label => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static TextStyle get button => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );
}