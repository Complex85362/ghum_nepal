import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class AuthHeroPanel extends StatelessWidget {
  final String imageUrl;
  final Widget? topLeft;
  final String title;
  final String subtitle;
  final bool isMobile;

  const AuthHeroPanel({
    super.key,
    required this.imageUrl,
    this.topLeft,
    required this.title,
    required this.subtitle,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        Image.network(imageUrl, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.05),
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),
        if (topLeft != null)
          Positioned(
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            child: topLeft!,
          ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: isMobile
                    ? AppTextStyles.displayLargeMobile
                    : AppTextStyles.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(subtitle, style: AppTextStyles.subtitle),
            ],
          ),
        ),
      ],
    );

    if (isMobile) {
      return SizedBox(height: 260, child: content);
    }
    return Expanded(flex: 5, child: content);
  }
}