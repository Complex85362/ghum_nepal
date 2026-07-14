import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../widgets/app_top_nav.dart';
import '../../widgets/destination_card.dart';
import 'category_screen.dart';


class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _exploreCategories = const [
    {'title': 'Hikes', 'category': 'hikes', 'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306'},
    {'title': 'Food Spots', 'category': 'food', 'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'},
    {'title': 'View Points', 'category': 'viewpoints', 'image': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa'},
    {'title': 'Lakes', 'category': 'lakes', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4'},
  ];

  final _cities = const [
    {'title': 'Kathmandu', 'image': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf'},
    {'title': 'Pokhara', 'image': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa'},
    {'title': 'Chitwan', 'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615'},
    {'title': 'Lumbini', 'image': 'https://images.unsplash.com/photo-1580500550469-9b5e70b4fd4e'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      appBar: const AppTopNav(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroBanner(isMobile),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore Nepal', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSpacing.md),
                  _categoryGrid(isMobile),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryScreen(category: 'hikes', title: 'Hikes'),
                        ),
                      ),
                      child: const Text('View More'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _knowPlacesBanner(isMobile),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover the cities of Nepal', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSpacing.md),
                  _cityGrid(isMobile),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('View More'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _heroBanner(bool isMobile) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nepal at your FingerTips', style: AppTextStyles.displayLarge),
                const SizedBox(height: AppSpacing.sm),
                Text('Experience the true beauty of Nepal Upclose!!',
                    style: AppTextStyles.subtitle),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryScreen(category: 'hikes', title: 'Hikes'),
                    ),
                  ),
                  child: const Text('Discover'),
                ),


              ],
            ),
          ),
          SizedBox(height: isMobile ? AppSpacing.md : 0, width: isMobile ? 0 : AppSpacing.lg),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Image.network(
                'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
                height: isMobile ? 200 : 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _knowPlacesBanner(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Image.network(
                'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
                height: isMobile ? 180 : 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: isMobile ? AppSpacing.md : 0, width: isMobile ? 0 : AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Know Places?', style: AppTextStyles.heading1.copyWith(color: Colors.white)),
                const SizedBox(height: AppSpacing.sm),
                Text('Publish your own stories and experiences', style: AppTextStyles.subtitle),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Submission form coming next.')),
                    );
                  },
                  child: const Text('Publish'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryGrid(bool isMobile) {
    final crossAxisCount = isMobile ? 2 : 4;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _exploreCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = _exploreCategories[index];
        return DestinationCard(
          imageUrl: item['image']!,
          title: item['title']!,
          height: double.infinity,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                category: item['category']!,
                title: item['title']!,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cityGrid(bool isMobile) {
    final crossAxisCount = isMobile ? 2 : 4;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = _cities[index];
        return DestinationCard(
          imageUrl: item['image']!,
          title: item['title']!,
          height: double.infinity,
          onTap: () {},
        );
      },
    );
  }

  Widget _footer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Wrap(
        spacing: AppSpacing.xl,
        runSpacing: AppSpacing.md,
        children: [
          _footerColumn('Find Us', ['Our locations', 'Contact Us']),
          _footerColumn('About us', ['Our Story', 'Our Products']),
          _footerColumn('Our Terms & Conditions', ['Terms of delivery', 'Privacy Setting']),
        ],
      ),
    );
  }

  Widget _footerColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        ...items.map((i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(i, style: AppTextStyles.caption),
        )),
      ],
    );
  }
}