import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/state_view.dart';
import '../../providers/destination_provider.dart';
import '../../widgets/app_top_nav.dart';
import '../destination_detail/destination_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final String title;

  const CategoryScreen({super.key, required this.category, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DestinationProvider>().loadCategory(widget.category);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final provider = context.watch<DestinationProvider>();

    return Scaffold(
      appBar: const AppTopNav(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.md),
              color: AppColors.primary,
              child: Column(
                children: [
                  Text(widget.title,
                      style: AppTextStyles.displayLarge, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.lg),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover ${widget.title} Around Nepal', style: AppTextStyles.heading2),
                  const SizedBox(height: AppSpacing.md),
                  StateView<List<dynamic>>(
                    state: provider.categoryState,
                    onRetry: () => provider.loadCategory(widget.category),
                    builder: (context, data) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : 4,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: isMobile ? 1.5 : 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final d = data[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DestinationDetailScreen(destinationId: d.id),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.divider),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(AppSpacing.radiusSm)),
                                    child: Image.network(
                                      d.coverImageUrl,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                          height: 100, color: AppColors.divider),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(AppSpacing.sm),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(d.name,
                                            style: AppTextStyles.label
                                                .copyWith(color: AppColors.primary)),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(d.shortDescription,
                                            style: AppTextStyles.caption,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}