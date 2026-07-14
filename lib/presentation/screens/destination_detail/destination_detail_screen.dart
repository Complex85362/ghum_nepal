import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/view_state.dart';
import '../../../core/widgets/state_view.dart';
import '../../../data/models/destination_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/destination_repository.dart';
import '../../../data/repositories/review_repository.dart';
import '../../widgets/app_top_nav.dart';
import '../map/destination_map_view.dart';

class DestinationDetailScreen extends StatefulWidget {
  final String destinationId;
  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen>
    with SingleTickerProviderStateMixin {
  final _destinationRepo = DestinationRepository();
  final _reviewRepo = ReviewRepository();

  ViewState<DestinationModel> _destinationState = const ViewLoading();
  ViewState<List<ReviewModel>> _reviewsState = const ViewLoading();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _destinationState = const ViewLoading());
    try {
      final destination = await _destinationRepo.getById(widget.destinationId);
      setState(() => _destinationState = ViewLoaded(destination));
    } catch (e) {
      setState(() => _destinationState = ViewFailed(e.toString()));
    }
    try {
      final reviews = await _reviewRepo.getForDestination(widget.destinationId);
      setState(() => _reviewsState = reviews.isEmpty
          ? const ViewEmpty(message: 'No reviews yet. Be the first!')
          : ViewLoaded(reviews));
    } catch (e) {
      setState(() => _reviewsState = ViewFailed(e.toString()));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    return Scaffold(
      appBar: const AppTopNav(),
      body: StateView<DestinationModel>(
        state: _destinationState,
        onRetry: _load,
        builder: (context, destination) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                destination.coverImageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(height: 240, color: AppColors.divider),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(destination.name,
                        style: AppTextStyles.heading1, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    isMobile
                        ? Column(children: _galleryChildren(destination, isMobile))
                        : Row(children: _galleryChildren(destination, isMobile)),
                    const SizedBox(height: AppSpacing.lg),
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Details'),
                        Tab(text: 'Map'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _textTab('Overview', destination.overview),
                          _textTab('Details', destination.details),
                          DestinationMapView(
                            latitude: destination.latitude,
                            longitude: destination.longitude,
                            title: destination.name,
                          ),
                          _reviewsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _galleryChildren(DestinationModel destination, bool isMobile) {
    if (destination.galleryImageUrls.isEmpty) return [];
    return destination.galleryImageUrls.take(2).map((url) {
      final img = ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Image.network(url, height: 120, fit: BoxFit.cover, width: double.infinity),
      );
      return isMobile
          ? Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: img)
          : Expanded(child: Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: img));
    }).toList();
  }

  Widget _textTab(String title, String content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Text(content, style: AppTextStyles.bodyMedium),
    );
  }

  Widget _reviewsTab() {
    return StateView<List<ReviewModel>>(
      state: _reviewsState,
      onRetry: _load,
      builder: (context, reviews) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final r = reviews[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.reviewerName,
                      style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                  Row(
                    children: List.generate(
                      5,
                          (i) => Icon(
                        i < r.rating ? Icons.star : Icons.star_border,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(r.comment, style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          },
        );
      },
    );
  }
}