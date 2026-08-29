import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../../core/widgets/max_width_box.dart';
import '../../../../core/widgets/app_top_nav.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/destination_entity.dart';
import '../../domain/entities/itinerary_step_entity.dart';
import '../../domain/usecases/get_destination_by_id_usecase.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../../../review/presentation/providers/review_provider.dart';
import '../../../review/presentation/widgets/review_list.dart';
import '../widgets/destination_map_view.dart';

class DestinationDetailScreen extends StatefulWidget {
  final String destinationId;
  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  late final GetDestinationByIdUseCase _getByIdUseCase;
  ViewState<DestinationEntity> _destinationState = const ViewLoading();

  @override
  void initState() {
    super.initState();
    _getByIdUseCase = context.read<GetDestinationByIdUseCase>();
    _load();
  }

  Future<void> _load() async {
    setState(() => _destinationState = const ViewLoading());
    final result = await _getByIdUseCase(GetDestinationByIdParams(widget.destinationId));
    switch (result) {
      case Success<DestinationEntity>(:final data):
        setState(() => _destinationState = ViewLoaded(data));
        final auth = context.read<AuthProvider>();
        if (auth.user != null && mounted) {
          context.read<WishlistProvider>().loadWishlist(auth.user!.uid);
        }
        if (mounted) {
          context.read<ReviewProvider>().loadReviews(widget.destinationId);
        }
      case Error<DestinationEntity>(:final failure):
        setState(() => _destinationState = ViewFailed(failure.message));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      appBar: const AppTopNav(),
      drawer: const AppSidebar(),
      body: StateView<DestinationEntity>(
        state: _destinationState,
        onRetry: _load,
        builder: (context, destination) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroImage(destination, isMobile),
              MaxWidthBox(
                maxWidth: 1000,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleRow(destination, isMobile),
                      const SizedBox(height: AppSpacing.lg),
                      _quickStats(destination, isMobile),
                      const SizedBox(height: AppSpacing.xl),
                      _sectionHeader(Icons.menu_book_outlined, 'Overview'),
                      const SizedBox(height: AppSpacing.sm),
                      Text(destination.overview, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.lg),
                      _sectionHeader(Icons.info_outline, 'Details'),
                      const SizedBox(height: AppSpacing.sm),
                      Text(destination.details, style: AppTextStyles.bodyMedium),
                      if (destination.tags.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: destination.tags
                              .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            ),
                            child: Text('#$t',
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700)),
                          ))
                              .toList(),
                        ),
                      ],
                      if (destination.itinerarySteps.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _itinerarySection(destination.itinerarySteps),
                      ],
                      if (destination.galleryImageUrls.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _sectionHeader(Icons.photo_library_outlined, 'Captured by the Community'),
                        const SizedBox(height: AppSpacing.sm),
                        _galleryGrid(destination.galleryImageUrls, isMobile),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      _sectionHeader(Icons.map_outlined, 'Route Map'),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 320,
                        child: DestinationMapView(
                          latitude: destination.latitude,
                          longitude: destination.longitude,
                          title: destination.name,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _sectionHeader(Icons.reviews_outlined, 'Reviews'),
                      SizedBox(
                        height: 420,
                        child: ReviewList(destinationId: widget.destinationId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroImage(DestinationEntity destination, bool isMobile) {
    return SizedBox(
      height: isMobile ? 260 : 400,
      width: double.infinity,
      child: Image.network(
        destination.coverImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(color: AppColors.surfaceContainer),
      ),
    );
  }

  Widget _titleRow(DestinationEntity destination, bool isMobile) {
    return Consumer2<AuthProvider, WishlistProvider>(
      builder: (context, auth, wishlist, _) {
        final saved = wishlist.isSaved(destination.id);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${destination.province.toUpperCase()}, NEPAL',
                          style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.name,
                    style: isMobile ? AppTextStyles.heading2 : AppTextStyles.heading1,
                  ),
                  const SizedBox(height: 2),
                  Text(destination.categoryName,
                      style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: auth.user == null
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Log in to save destinations.')),
              )
                  : () => wishlist.toggle(auth.user!.uid, destination),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              icon: Icon(saved ? Icons.favorite : Icons.favorite_border, size: 16),
              label: Text(saved ? 'Saved' : 'Save to Wishlist'),
            ),
          ],
        );
      },
    );
  }

  Widget _quickStats(DestinationEntity destination, bool isMobile) {
    final stats = <_StatItem>[
      if (destination.altitude != null)
        _StatItem(Icons.terrain_outlined, 'ALTITUDE', '${destination.altitude}m'),
      _StatItem(Icons.landscape_outlined, 'DIFFICULTY', destination.difficulty),
      if (destination.bestTimeToVisit.isNotEmpty)
        _StatItem(Icons.calendar_month_outlined, 'BEST TIME', destination.bestTimeToVisit),
      _StatItem(Icons.payments_outlined, 'EST. COST', 'NPR ${destination.estimatedBudgetNpr}'),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : stats.length,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: isMobile ? 1.6 : 1.3,
      children: stats
          .map((s) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(s.icon, color: AppColors.secondary, size: 20),
            const SizedBox(height: 6),
            Text(s.label, style: AppTextStyles.caption),
            Text(s.value, style: AppTextStyles.label),
          ],
        ),
      ))
          .toList(),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.heading3),
      ],
    );
  }

  Widget _itinerarySection(List<ItineraryStepEntity> steps) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.directions_walk_outlined, 'The Journey Ahead'),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: Text('${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title, style: AppTextStyles.label),
                        const SizedBox(height: 2),
                        Text(step.description,
                            style: AppTextStyles.caption.copyWith(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _galleryGrid(List<String> urls, bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: urls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Image.network(
            urls[index],
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: AppColors.surfaceContainer),
          ),
        );
      },
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  const _StatItem(this.icon, this.label, this.value);
}