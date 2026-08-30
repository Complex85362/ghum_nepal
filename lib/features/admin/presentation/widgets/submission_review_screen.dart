import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../destination/domain/entities/destination_entity.dart';
import '../../../destination/domain/usecases/update_destination_usecase.dart';
import '../../../destination/domain/usecases/approve_submission_usecase.dart';
import '../../../destination/domain/usecases/reject_submission_usecase.dart';

class SubmissionReviewScreen extends StatefulWidget {
  final DestinationEntity destination;
  final VoidCallback onFinished;

  const SubmissionReviewScreen({
    super.key,
    required this.destination,
    required this.onFinished,
  });

  @override
  State<SubmissionReviewScreen> createState() => _SubmissionReviewScreenState();
}

class _SubmissionReviewScreenState extends State<SubmissionReviewScreen> {
  late String _selectedCoverUrl;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _selectedCoverUrl = widget.destination.coverImageUrl;
  }

  List<String> get _allPhotos => [
    widget.destination.coverImageUrl,
    ...widget.destination.galleryImageUrls,
  ];

  Future<void> _approve() async {
    setState(() => _processing = true);
    final d = widget.destination;

    if (_selectedCoverUrl != d.coverImageUrl) {
      final newGallery = _allPhotos.where((url) => url != _selectedCoverUrl).toList();
      await context.read<UpdateDestinationUseCase>().call(
        UpdateDestinationParams(
          id: d.id,
          data: {
            'coverImageUrl': _selectedCoverUrl,
            'galleryImageUrls': newGallery,
          },
        ),
      );
    }

    await context.read<ApproveSubmissionUseCase>().call(d.id);
    setState(() => _processing = false);
    if (mounted) {
      Navigator.pop(context);
      widget.onFinished();
    }
  }

  Future<void> _reject() async {
    setState(() => _processing = true);
    await context.read<RejectSubmissionUseCase>().call(widget.destination.id);
    setState(() => _processing = false);
    if (mounted) {
      Navigator.pop(context);
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.destination;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        title: Text('Submission Review', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroWithChangeCover(d),
            const SizedBox(height: AppSpacing.lg),
            Text(d.name, style: AppTextStyles.heading1),
            Text('${d.province} · ${d.categoryName}', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.lg),

            _card(
              title: 'Location Metadata',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Category', d.categoryName),
                  _infoRow('Province', d.province),
                  _infoRow('Difficulty', d.difficulty),
                  _infoRow('Estimated Cost', 'NPR ${d.estimatedBudgetNpr}'),
                  if (d.altitude != null) _infoRow('Altitude', '${d.altitude}m'),
                  if (d.bestTimeToVisit.isNotEmpty) _infoRow('Best Time', d.bestTimeToVisit),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Overview', style: AppTextStyles.label),
                  const SizedBox(height: 4),
                  Text(d.overview, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Details', style: AppTextStyles.label),
                  const SizedBox(height: 4),
                  Text(d.details, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            if (d.itinerarySteps.isNotEmpty)
              _card(
                title: 'Journey Steps',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: d.itinerarySteps
                      .asMap()
                      .entries
                      .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text('${e.key + 1}. ${e.value.title} — ${e.value.description}',
                        style: AppTextStyles.bodyMedium),
                  ))
                      .toList(),
                ),
              ),
            const SizedBox(height: AppSpacing.md),

            _card(
              title: 'Submission Timeline',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timelineDot('Submitted', _formatDate(d.createdAt), filled: true),
                  _timelineDot('Awaiting review', 'Pending admin action', filled: false),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _processing ? null : _reject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _processing ? null : _approve,
                  child: _processing
                      ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Approve Submission'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroWithChangeCover(DestinationEntity d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Image.network(
            _selectedCoverUrl,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(height: 260, color: AppColors.surfaceContainer),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Tap a photo below to set it as the cover image', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _allPhotos.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final url = _allPhotos[index];
              final isSelected = url == _selectedCoverUrl;
              return GestureDetector(
                onTap: () => setState(() => _selectedCoverUrl = url),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm - 2),
                    child: Image.network(url, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(label, style: AppTextStyles.caption)),
          Expanded(child: Text(value, style: AppTextStyles.label)),
        ],
      ),
    );
  }

  Widget _timelineDot(String title, String subtitle, {required bool filled}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? AppColors.secondary : AppColors.divider,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.label),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}