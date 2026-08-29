import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/admin_content_box.dart';
import '../../data/models/destination_model.dart';
import '../../domain/usecases/update_destination_usecase.dart';
import '../../domain/usecases/delete_destination_usecase.dart';
import '../../../../core/widgets/responsive_layout.dart';
import 'edit_destination_screen.dart';
class AdminDestinationsScreen extends StatefulWidget {
  const AdminDestinationsScreen({super.key});

  @override
  State<AdminDestinationsScreen> createState() => _AdminDestinationsScreenState();
}

class _AdminDestinationsScreenState extends State<AdminDestinationsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateUseCase = context.read<UpdateDestinationUseCase>();
    final deleteUseCase = context.read<DeleteDestinationUseCase>();
    final isMobile = ResponsiveLayout.isMobile(context);
    return AdminContentBox(
      maxWidth: 1100,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Approved Locations', style: AppTextStyles.heading2),
              ],
            ),
            Text('Manage live locations across the platform.', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.lg),

            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: const InputDecoration(
                hintText: 'Search by name or district...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('destinations')
                  .where('approved', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  );
                }
                if (snapshot.hasError) {
                  return const Text('Could not load destinations.',
                      style: TextStyle(color: AppColors.error));
                }
                var docs = snapshot.data?.docs ?? [];
                var destinations = docs
                    .map((d) => DestinationModel.fromMap(
                    d.data() as Map<String, dynamic>, d.id))
                    .toList();

                if (_query.isNotEmpty) {
                  destinations = destinations
                      .where((d) =>
                  d.name.toLowerCase().contains(_query) ||
                      d.province.toLowerCase().contains(_query))
                      .toList();
                }

                if (destinations.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Text('No approved destinations found.'),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: destinations.length,
                  separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 1),
                  itemBuilder: (context, index) {
                    final d = destinations[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(d.coverImageUrl,
                                width: 56, height: 56, fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    Container(width: 56, height: 56, color: AppColors.surfaceContainer)),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.name, style: AppTextStyles.label),
                                Text(d.province, style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          // The category badge is the first thing to go on
                          // narrow screens — three icon buttons plus a fixed
                          // badge plus two flexible text columns is too much
                          // to fit on a phone width without everything
                          // getting squeezed to the point of overflowing.
                          if (!isMobile)
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                ),
                                child: Text(d.categoryName,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.caption.copyWith(color: AppColors.secondary)),
                              ),
                            ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                            tooltip: 'Edit',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditDestinationScreen(destination: d),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              d.isFeatured ? Icons.star : Icons.star_border,
                              color: AppColors.primary,
                            ),
                            tooltip: 'Toggle featured',
                            onPressed: () => updateUseCase(
                              UpdateDestinationParams(
                                id: d.id,
                                data: {'isFeatured': !d.isFeatured},
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
                            tooltip: 'Delete',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete destination?'),
                                  content: Text('This permanently removes "${d.name}".'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Delete')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await deleteUseCase(d.id);
                              }
                            },
                          ),
                        ],
                      ),
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