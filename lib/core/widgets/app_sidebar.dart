import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../router/app_router.dart';
import '../widgets/app_logo.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/destination/presentation/screens/wishlist_screen.dart';

/// The mobile navigation drawer, opened via the hamburger icon in
/// [AppTopNav].
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.user?.role == 'admin';
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: AppColors.navDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.lg,
              ),
              child: AppLogo(size: 32, textColor: Colors.white),
            ),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: AppSpacing.sm),
            _tile(
              context,
              icon: Icons.explore_outlined,
              label: 'Discover',
              selected: currentRoute == AppRoutes.home,
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != AppRoutes.home) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                }
              },
            ),
            _tile(
              context,
              icon: Icons.add_location_alt_outlined,
              label: 'Submit a Place',
              selected: currentRoute == AppRoutes.submit,
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != AppRoutes.submit) {
                  Navigator.pushNamed(context, AppRoutes.submit);
                }
              },
            ),
            _tile(
              context,
              icon: Icons.bookmark_border,
              label: 'Wishlist',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                );
              },
            ),
            _tile(
              context,
              icon: Icons.person_outline,
              label: 'Profile',
              selected: currentRoute == AppRoutes.profile,
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != AppRoutes.profile) {
                  Navigator.pushNamed(context, AppRoutes.profile);
                }
              },
            ),
            if (isAdmin)
              _tile(
                context,
                icon: Icons.admin_panel_settings_outlined,
                label: 'Admin Panel',
                selected: currentRoute == AppRoutes.admin,
                onTap: () {
                  Navigator.pop(context);
                  if (currentRoute != AppRoutes.admin) {
                    Navigator.pushNamed(context, AppRoutes.admin);
                  }
                },
              ),
            const Spacer(),
            if (auth.user != null) ...[
              const Divider(color: Colors.white24, height: 1),
              _tile(
                context,
                icon: Icons.logout,
                label: 'Log Out',
                onTap: () async {
                  Navigator.pop(context);
                  await context.read<AuthProvider>().logOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                  }
                },
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _tile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        bool selected = false,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}