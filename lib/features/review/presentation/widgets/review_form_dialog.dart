import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/review_entity.dart';
import '../providers/review_provider.dart';

class ReviewFormDialog extends StatefulWidget {
  final String destinationId;
  final String userId;
  final String reviewerName;
  final ReviewEntity? existing;

  const ReviewFormDialog({
    super.key,
    required this.destinationId,
    required this.userId,
    required this.reviewerName,
    this.existing,
  });

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  late int _rating;
  late TextEditingController _commentController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _commentController = TextEditingController(text: widget.existing?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
    if (mounted) {
      setState(() => _saving = false);
      if (success) Navigator.pop(context);
    }
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
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
              : const Text('Submit'),
        ),
      ],
    );
  }
}