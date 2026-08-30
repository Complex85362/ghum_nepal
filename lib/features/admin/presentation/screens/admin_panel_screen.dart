import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/admin_content_box.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../destination/domain/entities/destination_entity.dart';
import '../../../destination/presentation/providers/admin_provider.dart';
import '../../../destination/presentation/screens/admin_destinations_screen.dart';
import '../../../category/presentation/screens/category_management_screen.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/submission_review_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadPending();
    });
  }

  void _onSelect(int index) {
    if (index == 3) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.navDark,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Admin Panel', style: TextStyle(color: Colors.white)),
        ),
        drawer: Drawer(
          child: AdminSidebar(
            selectedIndex: _selectedIndex,
            onSelect: (i) {
              _onSelect(i);
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(child: _content()),
      );
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 240,
            child: AdminSidebar(selectedIndex: _selectedIndex, onSelect: _onSelect),
          ),
          Expanded(child: SingleChildScrollView(child: _content())),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_selectedIndex) {
      case 1:
        return const AdminDestinationsScreen();
      case 2:
        return const CategoryManagementScreen();
      case 0:
      default:
        return _submissionsContent();
    }
  }

  Widget _submissionsContent() {
    final provider = context.watch<AdminProvider>();
    final isMobile = ResponsiveLayout.isMobile(context);

    return AdminContentBox(
      maxWidth: 1100,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pending Reviews', style: AppTextStyles.heading2),
            Text('Review and moderate user-submitted locations across Nepal.',
                style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xl),
            StateView<List<DestinationEntity>>(
              state: provider.pendingState,
              onRetry: () => provider.loadPending(),
              builder: (context, submissions) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = isMobile ? 1 : 3;
                    final spacing = AppSpacing.md;
                    final cardWidth = columns == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - spacing * (columns - 1)) / columns;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: submissions.map((s) {
                        return SizedBox(
                          width: cardWidth,
                          child: _SubmissionCard(
                            destination: s,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubmissionReviewScreen(
                                  destination: s,
                                  onFinished: () => provider.loadPending(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  final DestinationEntity destination;
  final VoidCallback onTap;

  const _SubmissionCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Image.network(
                destination.coverImageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(height: 100, color: AppColors.surfaceContainer),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(destination.name,
                style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 16)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              destination.shortDescription,
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Text('Tap to review', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}