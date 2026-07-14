import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/responsive_layout.dart';
import '../screens/home_feed/search_screen.dart';

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
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/home'),
              child: Text(
                'LOGO',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 20,
                ),
              ),
            ),
            const Spacer(),
            if (!isMobile) ...[
              TextButton(
                onPressed: () {},
                child: const Text('Submit', style: TextStyle(color: AppColors.primary)),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Discover', style: TextStyle(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
              child: Container(
                width: isMobile ? 44 : 200,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, color: AppColors.primary, size: 20),
                    if (!isMobile) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text('Search', style: TextStyle(color: AppColors.textSecondary.withOpacity(0.7))),
                    ],
                  ],
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