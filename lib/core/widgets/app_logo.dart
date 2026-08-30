import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Renders the GhumNepal brand mark. Set [showWordmark] to false for
/// icon-only contexts (e.g. tight mobile nav bars).
class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 32,
    this.showWordmark = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.25),
          child: Image.asset(
            'assets/images/logo.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(size * 0.25),
              ),
              child: Icon(Icons.landscape_outlined, color: Colors.white, size: size * 0.6),
            ),
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(width: 8),
          Text(
            'GhumNepal',
            style: AppTextStyles.heading3.copyWith(
              color: textColor ?? AppColors.primary,
              fontSize: size * 0.55,
            ),
          ),
        ],
      ],
    );
  }
}