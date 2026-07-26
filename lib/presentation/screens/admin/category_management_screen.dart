import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/state_view.dart';
import '../../../data/models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../widgets/media_uploader.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  void _openForm({CategoryModel? existing}) {
    showDialog(
      context: context,
      builder: (_) => _CategoryFormDialog(existing: existing),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: AppTextStyles.heading2),
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Category'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          StateView<List<CategoryModel>>(
            state: provider.categoriesState,
            onRetry: () => provider.loadCategories(),
            builder: (context, categories) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final c = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSm)),
                          child: Image.network(
                            c.coverImageUrl,
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (c2, e, s) => Container(height: 80, color: AppColors.divider),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(c.name,
                                    style: AppTextStyles.label, overflow: TextOverflow.ellipsis),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                                onPressed: () => _openForm(existing: c),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete category?'),
                                      content: Text(
                                          'This will not delete destinations already assigned to "${c.name}".'),
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
                                    await context.read<CategoryProvider>().deleteCategory(c.id);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
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

class _CategoryFormDialog extends StatefulWidget {
  final CategoryModel? existing;
  const _CategoryFormDialog({this.existing});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  late TextEditingController _nameController;
  String? _imageUrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _imageUrl = widget.existing?.coverImageUrl;
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and image are required.')),
      );
      return;
    }
    setState(() => _saving = true);
    final provider = context.read<CategoryProvider>();
    final name = _nameController.text.trim();
    final slug = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    final category = CategoryModel(
      id: widget.existing?.id ?? '',
      name: name,
      slug: slug,
      coverImageUrl: _imageUrl!,
    );
    final success = widget.existing == null
        ? await provider.createCategory(category)
        : await provider.updateCategory(widget.existing!.id, category);
    setState(() => _saving = false);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add category' : 'Edit category'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category name'),
            ),
            const SizedBox(height: AppSpacing.md),
            MediaUploader(
              folder: 'categories',
              initialUrl: _imageUrl,
              onUploaded: (url) => setState(() => _imageUrl = url),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
              height: 16, width: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Save'),
        ),
      ],
    );
  }
}