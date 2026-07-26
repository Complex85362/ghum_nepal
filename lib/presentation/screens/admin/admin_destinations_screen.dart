import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/destination_model.dart';
import '../../../data/repositories/destination_repository.dart';

class AdminDestinationsScreen extends StatefulWidget {
  const AdminDestinationsScreen({super.key});

  @override
  State<AdminDestinationsScreen> createState() => _AdminDestinationsScreenState();
}

class _AdminDestinationsScreenState extends State<AdminDestinationsScreen> {
  final _repository = DestinationRepository();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All destinations', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('destinations').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (snapshot.hasError) {
                return const Text('Could not load destinations.',
                    style: TextStyle(color: AppColors.error));
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Text('No destinations yet.');
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const Divider(color: AppColors.divider),
                itemBuilder: (context, index) {
                  final d = DestinationModel.fromMap(
                      docs[index].data() as Map<String, dynamic>, docs[index].id);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(d.coverImageUrl,
                          width: 48, height: 48, fit: BoxFit.cover,
                          errorBuilder: (c, e, s) =>
                              Container(width: 48, height: 48, color: AppColors.divider)),
                    ),
                    title: Text(d.name, style: AppTextStyles.label),
                    subtitle: Text('${d.categoryName} · ${d.approved ? "Approved" : "Pending"}',
                        style: AppTextStyles.caption),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            d.isFeatured ? Icons.star : Icons.star_border,
                            color: AppColors.primary,
                          ),
                          tooltip: 'Toggle featured',
                          onPressed: () =>
                              _repository.updateDestination(d.id, {'isFeatured': !d.isFeatured}),
                        ),
                        IconButton(
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
                              await _repository.deleteDestination(d.id);
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
    );
  }
}