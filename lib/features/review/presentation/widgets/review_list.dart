import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/review_entity.dart';
import '../providers/review_provider.dart';
import 'review_form_dialog.dart';

class ReviewList extends StatelessWidget {
  final String destinationId;

  const ReviewList({super.key, required this.destinationId});

  void _openReviewDialog(BuildContext context, ReviewEntity? existing) {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log in to write a review.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => ReviewFormDialog(
        destinationId: destinationId,
        userId: auth.user!.uid,
        reviewerName: auth.user!.username,
        existing: existing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final reviewProvider = context.watch<ReviewProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: ElevatedButton.icon(
            onPressed: () => _openReviewDialog(context, null),
            icon: const Icon(Icons.rate_review_outlined, size: 18),
            label: const Text('Write a review'),
          ),
        ),
        Expanded(
          child: StateView<List<ReviewEntity>>(
            state: reviewProvider.reviewsState,
            onRetry: () => reviewProvider.loadReviews(destinationId),
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
                                    icon: const Icon(Icons.edit,
                                        size: 16, color: AppColors.primary),
                                    onPressed: () => _openReviewDialog(context, r),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        size: 16, color: AppColors.error),
                                    onPressed: () async {
                                      await reviewProvider.deleteReview(destinationId, r.userId);
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