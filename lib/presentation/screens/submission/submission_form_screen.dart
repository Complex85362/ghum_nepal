import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/max_width_box.dart';
import '../../../core/widgets/state_view.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/destination_model.dart';
import '../../../data/repositories/destination_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/app_top_nav.dart';
import '../../widgets/media_uploader.dart';

class SubmissionFormScreen extends StatefulWidget {
  const SubmissionFormScreen({super.key});

  @override
  State<SubmissionFormScreen> createState() => _SubmissionFormScreenState();
}

class _SubmissionFormScreenState extends State<SubmissionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationRepo = DestinationRepository();

  final _nameController = TextEditingController();
  final _provinceController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _overviewController = TextEditingController();
  final _detailsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  String _difficulty = 'Easy';
  String? _coverImageUrl;
  bool _submitting = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _provinceController.dispose();
    _shortDescController.dispose();
    _overviewController.dispose();
    _detailsController.dispose();
    _budgetController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }
    if (_coverImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a cover image.')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to log in to submit a destination.')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final destination = DestinationModel(
        id: '',
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId!,
        categoryName: _selectedCategoryName ?? '',
        province: _provinceController.text.trim(),
        shortDescription: _shortDescController.text.trim(),
        overview: _overviewController.text.trim(),
        details: _detailsController.text.trim(),
        coverImageUrl: _coverImageUrl!,
        galleryImageUrls: const [],
        latitude: double.tryParse(_latController.text.trim()) ?? 0,
        longitude: double.tryParse(_lngController.text.trim()) ?? 0,
        difficulty: _difficulty,
        estimatedBudgetNpr: int.tryParse(_budgetController.text.trim()) ?? 0,
        averageRating: 0,
        reviewCount: 0,
        isFeatured: false,
        approved: false,
        submittedBy: auth.user!.uid,
        createdAt: DateTime.now(),
      );

      await _destinationRepo.submitDestination(destination);

      setState(() {
        _submitting = false;
        _submitted = true;
      });
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submission failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final auth = context.watch<AuthProvider>();

    if (auth.user == null) {
      return Scaffold(
        appBar: const AppTopNav(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Log in to submit a destination.'),
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

    if (_submitted) {
      return Scaffold(
        appBar: const AppTopNav(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 56),
                const SizedBox(height: AppSpacing.md),
                Text('Submitted for review', style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Your destination will appear publicly once an admin approves it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const AppTopNav(),
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 700,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Publish a destination', style: AppTextStyles.heading1),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Submissions are reviewed by an admin before appearing publicly.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _label('Cover image'),
                  MediaUploader(
                    folder: 'destinations',
                    onUploaded: (url) => setState(() => _coverImageUrl = url),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Destination name'),
                  TextFormField(
                    controller: _nameController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Category'),
                  Consumer<CategoryProvider>(
                    builder: (context, provider, _) {
                      return StateView<List<CategoryModel>>(
                        state: provider.categoriesState,
                        onRetry: () => provider.loadCategories(),
                        builder: (context, categories) {
                          return DropdownButtonFormField<String>(
                            value: _selectedCategoryId,
                            hint: const Text('Select a category'),
                            items: categories
                                .map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ))
                                .toList(),
                            onChanged: (value) {
                              final category = categories.firstWhere((c) => c.id == value);
                              setState(() {
                                _selectedCategoryId = value;
                                _selectedCategoryName = category.name;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Province'),
                  TextFormField(
                    controller: _provinceController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Short description'),
                  TextFormField(
                    controller: _shortDescController,
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Overview'),
                  TextFormField(
                    controller: _overviewController,
                    maxLines: 4,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Details (how to get there, tips, etc.)'),
                  TextFormField(
                    controller: _detailsController,
                    maxLines: 4,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  isMobile
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Latitude'),
                      TextFormField(
                        controller: _latController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _numberValidator,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _label('Longitude'),
                      TextFormField(
                        controller: _lngController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _numberValidator,
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Latitude'),
                            TextFormField(
                              controller: _latController,
                              keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                              validator: _numberValidator,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Longitude'),
                            TextFormField(
                              controller: _lngController,
                              keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                              validator: _numberValidator,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Difficulty'),
                  DropdownButtonFormField<String>(
                    value: _difficulty,
                    items: const ['Easy', 'Moderate', 'Hard']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) => setState(() => _difficulty = value ?? 'Easy'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Estimated budget (NPR)'),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final n = int.tryParse(v.trim());
                      if (n == null || n < 0) return 'Enter a valid non-negative number';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                          : const Text('Submit for review'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _numberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
    return null;
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Text(text, style: AppTextStyles.label),
  );
}