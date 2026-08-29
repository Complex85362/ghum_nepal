import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/max_width_box.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../../core/widgets/app_top_nav.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_provider.dart';
import '../../../destination/domain/entities/destination_entity.dart';
import '../../../destination/presentation/providers/destination_provider.dart';
import '../../../destination/presentation/screens/destination_detail_screen.dart';
import '../../../destination/presentation/screens/search_screen.dart';
import '../../../destination/presentation/widgets/discover_destination_card.dart';
import '../../../destination/presentation/screens/wishlist_screen.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../../core/widgets/app_sidebar.dart';
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _BudgetOption {
  final String label;
  final int? maxBudget;
  const _BudgetOption(this.label, this.maxBudget);
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  static const _budgetOptions = [
    _BudgetOption('Any Budget', null),
    _BudgetOption('Under Rs 2,000', 2000),
    _BudgetOption('Under Rs 5,000', 5000),
    _BudgetOption('Under Rs 10,000', 10000),
    _BudgetOption('Under Rs 20,000', 20000),
  ];

  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
      context.read<DestinationProvider>()
        ..loadFeatured()
        ..loadDiscoverFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    final body = SingleChildScrollView(
      child: MaxWidthBox(
        maxWidth: 1280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroSearch(isMobile),
            _filterBar(isMobile),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOP RATED THIS WEEK',
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary, fontWeight: FontWeight.w700)),
                          Text('Handpicked Adventures', style: AppTextStyles.heading2),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _handpickedSection(isMobile),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Discover Near You', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSpacing.md),
                  _discoverGrid(isMobile),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
            _footer(isMobile ? AppSpacing.md : AppSpacing.xl),
          ],
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(appBar: const AppTopNav(), body: body);
    }

    return Scaffold(
      appBar: const AppTopNav(),
      drawer: const AppSidebar(),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: (index) {
          setState(() => _bottomNavIndex = index);
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _heroSearch(bool isMobile) {
    return Container(
      height: isMobile ? 260 : 340,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.md : AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Where to next, Explorer?',
                    style: isMobile ? AppTextStyles.displayLargeMobile : AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      ),
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.primary),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Search trails, cities, or food spots...',
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar(bool isMobile) {
    final categoryProvider = context.watch<CategoryProvider>();
    final destinationProvider = context.watch<DestinationProvider>();

    // Compact chip list used for both layouts. On mobile it's placed
    // inside a horizontal SingleChildScrollView, so it must size itself
    // to its content (no Center/infinite-width widgets) rather than
    // expanding — that's what made the old ViewLoading/Failed states
    // from StateView unsafe to reuse verbatim here.
    List<Widget> categoryChipWidgets(List<CategoryEntity> categories) {
      return categories.map((c) {
        final selected = destinationProvider.selectedCategoryId == c.id;
        return _chip(c.name, selected, () => destinationProvider.setCategoryFilter(c.id));
      }).toList();
    }

    final categoryState = categoryProvider.categoriesState;
    final categoryChips = switch (categoryState) {
      ViewLoaded<List<CategoryEntity>>(:final data) => categoryChipWidgets(data),
      ViewLoading<List<CategoryEntity>>() => [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      ],
      _ => <Widget>[],
    };

    if (isMobile) {
      // On mobile the category list (Hikes, Cultural Sites, etc.) can
      // outgrow the screen width, so it scrolls horizontally as a
      // single row instead of wrapping into a tall block of chips.
      return Container(
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  _chip('All', destinationProvider.selectedCategoryId == null,
                          () => destinationProvider.setCategoryFilter(null)),
                  const SizedBox(width: AppSpacing.sm),
                  for (final chip in categoryChips) ...[
                    chip,
                    const SizedBox(width: AppSpacing.sm),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  _dropdown(
                    hint: 'Province',
                    value: destinationProvider.selectedProvince,
                    items: AppConstants.nepalProvinces,
                    onChanged: (v) => destinationProvider.setProvinceFilter(v),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _budgetDropdown(destinationProvider),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          _chip('All', destinationProvider.selectedCategoryId == null,
                  () => destinationProvider.setCategoryFilter(null)),
          ...categoryChips,
          const SizedBox(width: AppSpacing.md),
          _dropdown(
            hint: 'Province',
            value: destinationProvider.selectedProvince,
            items: AppConstants.nepalProvinces,
            onChanged: (v) => destinationProvider.setProvinceFilter(v),
          ),
          _budgetDropdown(destinationProvider),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.secondaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          hint: Text(hint, style: AppTextStyles.caption),
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text('All $hint', style: AppTextStyles.caption)),
            ...items.map((i) => DropdownMenuItem<String?>(value: i, child: Text(i, style: AppTextStyles.caption))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _budgetDropdown(DestinationProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: provider.selectedMaxBudget,
          hint: Text('Budget (NPR)', style: AppTextStyles.caption),
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: _budgetOptions
              .map((o) => DropdownMenuItem<int?>(value: o.maxBudget, child: Text(o.label, style: AppTextStyles.caption)))
              .toList(),
          onChanged: (v) => provider.setBudgetFilter(v),
        ),
      ),
    );
  }

  Widget _handpickedSection(bool isMobile) {
    final provider = context.watch<DestinationProvider>();
    return StateView<List<DestinationEntity>>(
      state: provider.featuredState,
      onRetry: () => provider.loadFeatured(),
      builder: (context, destinations) {
        final items = destinations.take(2).toList();
        if (isMobile) {
          return Column(
            children: items
                .map((d) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _handpickedCard(d, isMobile),
            ))
                .toList(),
          );
        }
        return Row(
          children: items
              .map((d) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: _handpickedCard(d, isMobile),
            ),
          ))
              .toList(),
        );
      },
    );
  }

  Widget _handpickedCard(DestinationEntity d, bool isMobile) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DestinationDetailScreen(destinationId: d.id)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: isMobile ? 16 / 10 : 16 / 9,
              child: Image.network(
                d.coverImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: AppColors.surfaceContainer),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(d.province,
                      style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                  Text(d.name,
                      style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DestinationDetailScreen(destinationId: d.id)),
                    ),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 36)),
                    child: const Text('Explore'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _discoverGrid(bool isMobile) {
    final provider = context.watch<DestinationProvider>();
    return StateView<List<DestinationEntity>>(
      state: provider.discoverFeedState,
      onRetry: () => provider.loadDiscoverFeed(),
      builder: (context, destinations) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: destinations.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final d = destinations[index];
            return DiscoverDestinationCard(
              destination: d,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DestinationDetailScreen(destinationId: d.id)),
              ),
            );
          },
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