import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/max_width_box.dart';
import '../../../core/widgets/state_view.dart';
import '../../../data/models/destination_model.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/admin_sidebar.dart';
import 'admin_destinations_screen.dart';
import 'category_management_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadPending();
    });
  }

  void _onSelect(int index) {
    if (index == 4) {
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
          backgroundColor: AppColors.primary,
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
            width: 220,
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
      case 3:
        return _submissionsContent();
      case 0:
      default:
        return _dashboardContent();
    }
  }

  Widget _dashboardContent() {
    return MaxWidthBox(
      maxWidth: 1000,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Use the sidebar to manage destinations, categories, and pending submissions.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submissionsContent() {
    final provider = context.watch<AdminProvider>();
    final isMobile = ResponsiveLayout.isMobile(context);

    return MaxWidthBox(
      maxWidth: 1000,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pending submissions', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.xl),
            StateView<List<DestinationModel>>(
              state: provider.pendingState,
              onRetry: () => provider.loadPending(),
              builder: (context, submissions) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: submissions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 3,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio: isMobile ? 1.6 : 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final s = submissions[index];
                    return _SubmissionCard(
                      destination: s,
                      onApprove: () => provider.approve(s.id),
                      onReject: () => provider.reject(s.id),
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
  final DestinationModel destination;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _SubmissionCard({
    required this.destination,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(destination.name,
              style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 16)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            destination.shortDescription,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Approve'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: onReject,
                icon: const Icon(Icons.close, color: AppColors.error),
                tooltip: 'Reject',
              ),
            ],
          ),
        ],
      ),
    );
  }
}