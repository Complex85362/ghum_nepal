import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/view_state.dart';
import '../../../core/widgets/state_view.dart';
import '../../../core/widgets/max_width_box.dart';
import '../../../data/models/destination_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/destination_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/review_provider.dart';
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

  ViewState<DestinationModel> _destinationState = const ViewLoading();
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

      final auth = context.read<AuthProvider>();
      if (auth.user != null && mounted) {
        context.read<WishlistProvider>().loadWishlist(auth.user!.uid);
      }
      if (mounted) {
        context.read<ReviewProvider>().loadReviews(widget.destinationId);
      }
    } catch (e) {
      setState(() => _destinationState = ViewFailed(e.toString()));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openReviewDialog(ReviewModel? existing) {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log in to write a review.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => _ReviewFormDialog(
        destinationId: widget.destinationId,
        userId: auth.user!.uid,
        reviewerName: auth.user!.username,
        existing: existing,
      ),
    );
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
          child: MaxWidthBox(
            maxWidth: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  destination.coverImageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 280, color: AppColors.divider),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              destination.name,
                              style: AppTextStyles.heading1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Consumer2<AuthProvider, WishlistProvider>(
                            builder: (context, auth, wishlist, _) {
                              final uid = auth.user?.uid;
                              final saved = wishlist.isSaved(destination.id);
                              return IconButton(
                                icon: Icon(
                                  saved ? Icons.bookmark : Icons.bookmark_border,
                                  color: AppColors.primary,
                                ),
                                onPressed: uid == null
                                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Log in to save destinations.')),
                                )
                                    : () => wishlist.toggle(uid, destination),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Center(
                        child: Text(destination.categoryName,
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
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
                        height: 460,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _textTab(destination.overview),
                            _textTab(destination.details),
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
      ),
    );
  }

  List<Widget> _galleryChildren(DestinationModel destination, bool isMobile) {
    if (destination.galleryImageUrls.isEmpty) return [];
    return destination.galleryImageUrls.take(2).map((url) {
      final img = ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Image.network(
          url,
          height: 140,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (c, e, s) => Container(height: 140, color: AppColors.divider),
        ),
      );
      return isMobile
          ? Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: img)
          : Expanded(
          child: Padding(padding: const EdgeInsets.only(right: AppSpacing.md), child: img));
    }).toList();
  }

  Widget _textTab(String content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Text(content, style: AppTextStyles.bodyMedium),
    );
  }

  Widget _reviewsTab() {
    final auth = context.watch<AuthProvider>();
    final reviewProvider = context.watch<ReviewProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: ElevatedButton.icon(
            onPressed: () => _openReviewDialog(null),
            icon: const Icon(Icons.rate_review_outlined, size: 18),
            label: const Text('Write a review'),
          ),
        ),
        Expanded(
          child: StateView<List<ReviewModel>>(
            state: reviewProvider.reviewsState,
            onRetry: () => reviewProvider.loadReviews(widget.destinationId),
            builder: (context, reviews) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final r = reviews[index];
                  final isOwner = auth.user?.uid == r.userId;
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r.reviewerName,
                                style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                            if (isOwner)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                                    onPressed: () => _openReviewDialog(r),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        size: 16, color: AppColors.error),
                                    onPressed: () async {
                                      await reviewProvider.deleteReview(
                                          widget.destinationId, r.userId);
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                          ],
                        ),
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
          ),
        ),
      ],
    );
  }
}

class _ReviewFormDialog extends StatefulWidget {
  final String destinationId;
  final String userId;
  final String reviewerName;
  final ReviewModel? existing;

  const _ReviewFormDialog({
    required this.destinationId,
    required this.userId,
    required this.reviewerName,
    this.existing,
  });

  @override
  State<_ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<_ReviewFormDialog> {
  late int _rating;
  late TextEditingController _commentController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _commentController = TextEditingController(text: widget.existing?.comment ?? '');
  }

  Future<void> _submit() async {
    if (_commentController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final success = await context.read<ReviewProvider>().submitReview(
      destinationId: widget.destinationId,
      userId: widget.userId,
      reviewerName: widget.reviewerName,
      rating: _rating,
      comment: _commentController.text.trim(),
    );
    setState(() => _saving = false);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Write a review' : 'Edit your review'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.primary,
                  ),
                  onPressed: () => setState(() => _rating = i + 1),
                );
              }),
            ),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Your review'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
              height: 16, width: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Submit'),
        ),
      ],
    );
  }
}