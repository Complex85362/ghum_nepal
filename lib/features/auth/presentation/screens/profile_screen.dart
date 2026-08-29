import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_nav.dart';
import '../../../../core/widgets/max_width_box.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../../core/widgets/media_uploader.dart';
import '../../../../core/result/result.dart';
import '../../../../core/widgets/view_state.dart';
import '../../../destination/domain/entities/destination_entity.dart';
import '../../../destination/domain/usecases/get_user_submissions_usecase.dart';
import '../../../destination/presentation/screens/destination_detail_screen.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../../../wishlist/domain/entities/wishlist_item_entity.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/app_sidebar.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tabIndex = 0;
  ViewState<List<DestinationEntity>> _submissionsState = const ViewLoading();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<WishlistProvider>().loadWishlist(auth.user!.uid);
        _loadSubmissions(auth.user!.uid);
      }
    });
  }

  Future<void> _loadSubmissions(String uid) async {
    setState(() => _submissionsState = const ViewLoading());
    final result = await context.read<GetUserSubmissionsUseCase>().call(uid);
    switch (result) {
      case Success<List<DestinationEntity>>(:final data):
        setState(() => _submissionsState = data.isEmpty
            ? const ViewEmpty(message: "You haven't submitted any destinations yet.")
            : ViewLoaded(data));
      case Error<List<DestinationEntity>>(:final failure):
        setState(() => _submissionsState = ViewFailed(failure.message));
    }
  }

  void _openEditNameDialog() {
    final auth = context.read<AuthProvider>();
    final controller = TextEditingController(text: auth.user?.username ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Full name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await auth.updateProfile(username: controller.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.user == null) {
      return Scaffold(
        appBar: const AppTopNav(),
        drawer: const AppSidebar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('You need to log in to view your profile.'),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    final user = auth.user!;
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      appBar: const AppTopNav(),
      drawer: const AppSidebar(),
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 1000,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerRow(user),
                const SizedBox(height: AppSpacing.lg),
                _statsBar(wishlist),
                const SizedBox(height: AppSpacing.lg),
                _tabBar(),
                const SizedBox(height: AppSpacing.md),
                _tabIndex == 0 ? _wishlistGrid(wishlist) : _submissionsGrid(),
                const SizedBox(height: AppSpacing.xl),
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (user.role == 'admin')
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/admin'),
                        icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
                        label: const Text('Admin Dashboard'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () async {
                        await auth.logOut();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      },
                      icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
                      label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerRow(user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.surfaceContainer,
              backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
              child: user.photoUrl.isEmpty
                  ? const Icon(Icons.person_outline, size: 40, color: AppColors.outline)
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(

                child: ClipOval(
                  child: MediaUploader(
                    folder: 'profile_photos',
                    width: 32,
                    height: 32,
                    onUploaded: (url) => context.read<AuthProvider>().updateProfile(photoUrl: url),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.username, style: AppTextStyles.heading2),
              const SizedBox(height: 2),
              Text(user.email, style: AppTextStyles.caption),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _openEditNameDialog,
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: const Text('Edit Profile'),
        ),
      ],
    );
  }

  Widget _statsBar(WishlistProvider wishlist) {
    final savedCount = wishlist.wishlistState is ViewLoaded<List<WishlistItemEntity>>
        ? (wishlist.wishlistState as ViewLoaded<List<WishlistItemEntity>>).data.length
        : 0;
    final submissionsCount = _submissionsState is ViewLoaded<List<DestinationEntity>>
        ? (_submissionsState as ViewLoaded<List<DestinationEntity>>).data.length
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('$savedCount', 'SAVED'),
          Container(width: 1, height: 32, color: AppColors.divider),
          _statItem('$submissionsCount', 'CONTRIBUTIONS'),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _tabBar() {
    return Row(
      children: [
        _tabButton('My Wishlist', 0),
        const SizedBox(width: AppSpacing.lg),
        _tabButton('My Submissions', 1),
      ],
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 2, width: 70, color: selected ? AppColors.primary : Colors.transparent),
        ],
      ),
    );
  }

  Widget _wishlistGrid(WishlistProvider wishlist) {
    return StateView<List<WishlistItemEntity>>(
      state: wishlist.wishlistState,
      onRetry: () {
        final auth = context.read<AuthProvider>();
        if (auth.user != null) wishlist.loadWishlist(auth.user!.uid);
      },
      builder: (context, items) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DestinationDetailScreen(destinationId: item.destinationId),
                ),
              ),
              child: _simpleCard(item.coverImageUrl, item.name, item.categoryName),
            );
          },
        );
      },
    );
  }

  Widget _submissionsGrid() {
    return StateView<List<DestinationEntity>>(
      state: _submissionsState,
      onRetry: () {
        final auth = context.read<AuthProvider>();
        if (auth.user != null) _loadSubmissions(auth.user!.uid);
      },
      builder: (context, items) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final d = items[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DestinationDetailScreen(destinationId: d.id)),
              ),
              child: _simpleCard(
                d.coverImageUrl,
                d.name,
                d.approved ? 'Approved' : 'Pending review',
              ),
            );
          },
        );
      },
    );
  }

  Widget _simpleCard(String imageUrl, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: AppColors.surfaceContainer),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}