import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/responsive_layout.dart';

class AppTopNav extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;

  const AppTopNav({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (isMobile)
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.primary),
                onPressed: onMenuTap,
              ),
            Text('LOGO',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 20,
                )),
            const Spacer(),
            if (!isMobile) ...[
              TextButton(
                onPressed: () {},
                child: const Text('Submit', style: TextStyle(color: AppColors.primary)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Discover', style: TextStyle(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            SizedBox(
              width: isMobile ? 130 : 200,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (!isMobile)
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
                onPressed: () {},
              ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: AppColors.primary),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}