import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'view_state.dart';

/// Renders loading / empty / error / content consistently across every screen.
class StateView<T> extends StatelessWidget {
  final ViewState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;

  const StateView({
    super.key,
    required this.state,
    required this.builder,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ViewLoading<T>():
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      case ViewEmpty<T>(:final message):
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_off_outlined,
                    size: 48, color: AppColors.textSecondary),
                const SizedBox(height: AppSpacing.sm),
                Text(message,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      case ViewFailed<T>(:final message):
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.error),
                const SizedBox(height: AppSpacing.sm),
                Text(message,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center),
                if (onRetry != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
                ]
              ],
            ),
          ),
        );
      case ViewLoaded<T>(:final data):
        return builder(context, data);
    }
  }
}