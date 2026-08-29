import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'responsive_layout.dart';
import 'app_logo.dart';
import '../../features/destination/presentation/screens/search_screen.dart';
import '../../features/destination/presentation/screens/wishlist_screen.dart';

class AppTopNav extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;

  const AppTopNav({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (isMobile)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.primary),
                  onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
                ),
              ),
            GestureDetector(
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/home') {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                }
              },
              child: AppLogo(
                size: isMobile ? 26 : 32,
                showWordmark: !isMobile,
                textColor: AppColors.primary,
              ),
            ),
            const Spacer(),
            if (!isMobile) ...[
              TextButton(
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != '/submit') {
                    Navigator.pushNamed(context, '/submit');
                  }
                },
                child: const Text('Submit', style: TextStyle(color: AppColors.primary)),
              ),
              TextButton(
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != '/home') {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  }
                },
                child: const Text('Discover', style: TextStyle(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.md),
            ] else
              IconButton(
                icon: const Icon(Icons.add_location_alt_outlined, color: AppColors.primary),
                tooltip: 'Submit a place',
                onPressed: () {
                  if (ModalRoute.of(context)?.settings.name != '/submit') {
                    Navigator.pushNamed(context, '/submit');
                  }
                },
              ),
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
            IconButton(
              icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: AppColors.primary),
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/profile') {
                  Navigator.pushNamed(context, '/profile');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}