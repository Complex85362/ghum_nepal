import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/max_width_box.dart';
import '../../../core/widgets/state_view.dart';
import '../../../data/models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../widgets/app_top_nav.dart';
import '../../widgets/destination_card.dart';
import 'category_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _cities = const [
    {'title': 'Kathmandu', 'image': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf'},
    {'title': 'Pokhara', 'image': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa'},
    {'title': 'Chitwan', 'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615'},
    {'title': 'Lumbini', 'image': 'https://images.unsplash.com/photo-1580500550469-9b5e70b4fd4e'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final hPad = isMobile ? AppSpacing.md : AppSpacing.xl;

    return Scaffold(
      appBar: const AppTopNav(),
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 1280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(hPad),
                child: _heroBanner(isMobile),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explore Nepal', style: AppTextStyles.heading2),
                    const SizedBox(height: AppSpacing.lg),
                    _categoryGrid(isMobile),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(hPad),
                child: _knowPlacesBanner(isMobile),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Discover the cities of Nepal', style: AppTextStyles.heading2),
                    const SizedBox(height: AppSpacing.lg),
                    _cityGrid(isMobile),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('View More'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _footer(hPad),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroBanner(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
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
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () {},
                  child: const Text('Discover'),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? AppSpacing.lg : 0, width: isMobile ? 0 : AppSpacing.xl),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Image.network(
                'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
                height: isMobile ? 200 : 280,
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
      padding: const EdgeInsets.all(AppSpacing.xl),
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
                height: isMobile ? 180 : 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: isMobile ? AppSpacing.lg : 0, width: isMobile ? 0 : AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Know Places?', style: AppTextStyles.heading1.copyWith(color: Colors.white)),
                const SizedBox(height: AppSpacing.sm),
                Text('Publish your own stories and experiences', style: AppTextStyles.subtitle),
                const SizedBox(height: AppSpacing.lg),
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
    final provider = context.watch<CategoryProvider>();
    return StateView<List<CategoryModel>>(
      state: provider.categoriesState,
      onRetry: () => provider.loadCategories(),
      builder: (context, categories) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final c = categories[index];
            return DestinationCard(
              imageUrl: c.coverImageUrl,
              title: c.name,
              height: double.infinity,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(categoryId: c.id, title: c.name),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _cityGrid(bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
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

  Widget _footer(double hPad) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.xl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Wrap(
        spacing: AppSpacing.xxl,
        runSpacing: AppSpacing.lg,
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