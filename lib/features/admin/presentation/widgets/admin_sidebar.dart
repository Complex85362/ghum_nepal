import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AdminSidebar({super.key, required this.selectedIndex, required this.onSelect});

  static const _items = [
    ('Pending Reviews', Icons.inbox_outlined),
    ('Approved Locations', Icons.map_outlined),
    ('Categories', Icons.category_outlined),
    ('Home Page', Icons.home_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navDark,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                const AppLogo(size: 28, textColor: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 36),
            child: Text('Admin Panel',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (int i = 0; i < _items.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: selectedIndex == i ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: ListTile(
                dense: true,
                leading: Icon(_items[i].$2, color: Colors.white, size: 20),
                title: Text(
                  _items[i].$1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: selectedIndex == i ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                onTap: () => onSelect(i),
              ),
            ),
        ],
      ),
    );
  }
}