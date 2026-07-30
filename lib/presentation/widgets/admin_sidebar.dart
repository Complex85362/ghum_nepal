import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AdminSidebar({super.key, required this.selectedIndex, required this.onSelect});

  static const _items = [
    ('Dashboard', Icons.dashboard_outlined),
    ('Destinations', Icons.map_outlined),
    ('Categories', Icons.category_outlined),
    ('Submissions', Icons.inbox_outlined),
    ('Home Page', Icons.home_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextButton.icon(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text('Back', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (int i = 0; i < _items.length; i++)
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(_items[i].$2, color: Colors.white),
                title: Text(
                  _items[i].$1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: selectedIndex == i ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: selectedIndex == i,
                selectedTileColor: Colors.white24,
                onTap: () => onSelect(i),
              ),
            ),
        ],
      ),
    );
  }
}