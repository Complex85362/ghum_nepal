import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_nav.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/max_width_box.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../wishlist/domain/entities/wishlist_item_entity.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import 'destination_detail_screen.dart';
import '../../../../core/widgets/app_sidebar.dart';
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<WishlistProvider>().loadWishlist(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final isMobile = ResponsiveLayout.isMobile(context);

    if (auth.user == null) {
      return Scaffold(
        appBar: const AppTopNav(),
        drawer: const AppSidebar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Log in to view your wishlist.'),
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

    return Scaffold(
      appBar: const AppTopNav(),
      drawer: const AppSidebar(),
      body: MaxWidthBox(
        maxWidth: 1100,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My wishlist', style: AppTextStyles.heading2),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: StateView<List<WishlistItemEntity>>(
                  state: wishlist.wishlistState,
                  onRetry: () => wishlist.loadWishlist(auth.user!.uid),
                  builder: (context, items) {
                    return GridView.builder(
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 2 : 4,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DestinationDetailScreen(
                                destinationId: item.destinationId,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  child: Image.network(
                                    item.coverImageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(color: AppColors.divider),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(item.name,
                                  style: AppTextStyles.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}