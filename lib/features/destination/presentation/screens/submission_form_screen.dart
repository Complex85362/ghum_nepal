import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/max_width_box.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../../core/widgets/app_top_nav.dart';
import '../../../../core/widgets/media_uploader.dart';
import '../../../../core/result/result.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/providers/category_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/destination_entity.dart';
import '../../domain/entities/itinerary_step_entity.dart';
import '../../domain/usecases/submit_destination_usecase.dart';
import '../../../../core/widgets/app_sidebar.dart';
class SubmissionFormScreen extends StatefulWidget {
  const SubmissionFormScreen({super.key});

  @override
  State<SubmissionFormScreen> createState() => _SubmissionFormScreenState();
}

class _ItineraryStepDraft {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }
}

class _SubmissionFormScreenState extends State<SubmissionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final SubmitDestinationUseCase _submitUseCase;

  final _nameController = TextEditingController();
  final _provinceController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _overviewController = TextEditingController();
  final _detailsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _altitudeController = TextEditingController();
  final _bestTimeController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  String _difficulty = 'Easy';
  final List<String> _photoUrls = [];
  final List<_ItineraryStepDraft> _itinerarySteps = [_ItineraryStepDraft()];
  bool _submitting = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _submitUseCase = context.read<SubmitDestinationUseCase>();
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
    _altitudeController.dispose();
    _bestTimeController.dispose();
    _tagsController.dispose();
    for (final step in _itinerarySteps) {
      step.dispose();
    }
    super.dispose();
  }

  void _addItineraryStep() {
    setState(() => _itinerarySteps.add(_ItineraryStepDraft()));
  }

  void _removeItineraryStep(int index) {
    setState(() {
      _itinerarySteps[index].dispose();
      _itinerarySteps.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }
    if (_photoUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one photo.')),
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

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final steps = _itinerarySteps
        .where((s) => s.titleController.text.trim().isNotEmpty)
        .map((s) => ItineraryStepEntity(
      title: s.titleController.text.trim(),
      description: s.descriptionController.text.trim(),
    ))
        .toList();

    final destination = DestinationEntity(
      id: '',
      name: _nameController.text.trim(),
      categoryId: _selectedCategoryId!,
      categoryName: _selectedCategoryName ?? '',
      province: _provinceController.text.trim(),
      shortDescription: _shortDescController.text.trim(),
      overview: _overviewController.text.trim(),
      details: _detailsController.text.trim(),
      coverImageUrl: _photoUrls.first,
      galleryImageUrls: _photoUrls.skip(1).toList(),
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
      altitude: int.tryParse(_altitudeController.text.trim()),
      bestTimeToVisit: _bestTimeController.text.trim(),
      tags: tags,
      itinerarySteps: steps,
    );

    final result = await _submitUseCase(destination);
    switch (result) {
      case Success<String>():
        setState(() {
          _submitting = false;
          _submitted = true;
        });
      case Error<String>():
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
        drawer: const AppSidebar(),
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
        drawer: const AppSidebar(),
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
      drawer: const AppSidebar(),
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
                  Text('Share a Hidden Gem', style: AppTextStyles.heading1, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Help the community discover the soul of Nepal. Submissions are reviewed before appearing publicly.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  _sectionTitle(Icons.badge_outlined, 'The Basics'),
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
                      return StateView<List<CategoryEntity>>(
                        state: provider.categoriesState,
                        onRetry: () => provider.loadCategories(),
                        builder: (context, categories) {
                          return DropdownButtonFormField<String>(
                            value: _selectedCategoryId,
                            hint: const Text('Select a category'),
                            items: categories
                                .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
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
                  const SizedBox(height: AppSpacing.xl),

                  _sectionTitle(Icons.landscape_outlined, 'The Adventure'),
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

                  _label('Tags (comma separated, e.g. HighAltitude, ReligiousSite)'),
                  TextFormField(controller: _tagsController),
                  const SizedBox(height: AppSpacing.xl),

                  _sectionTitle(Icons.directions_bus_filled_outlined, 'Logistics'),
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
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  const SizedBox(height: AppSpacing.md),

                  _label('Altitude in meters (optional)'),
                  TextFormField(
                    controller: _altitudeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Best time to visit (e.g. Aug - Oct)'),
                  TextFormField(controller: _bestTimeController),
                  const SizedBox(height: AppSpacing.xl),

                  _sectionTitle(Icons.route_outlined, 'The Journey Ahead'),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Add step-by-step directions for travelers.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...List.generate(_itinerarySteps.length, (index) {
                    final step = _itinerarySteps[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primary,
                            child: Text('${index + 1}',
                                style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: step.titleController,
                                  decoration: const InputDecoration(hintText: 'Step title'),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                TextField(
                                  controller: step.descriptionController,
                                  maxLines: 2,
                                  decoration: const InputDecoration(hintText: 'Step description'),
                                ),
                              ],
                            ),
                          ),
                          if (_itinerarySteps.length > 1)
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: AppColors.error),
                              onPressed: () => _removeItineraryStep(index),
                            ),
                        ],
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: _addItineraryStep,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add another step'),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  _sectionTitle(Icons.photo_library_outlined, 'Captured Moments'),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Upload up to 5 photos. The first photo becomes the cover image unless an admin changes it.',
                      style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (int i = 0; i < _photoUrls.length; i++)
                        Stack(
                          key: ValueKey('photo_${_photoUrls[i]}'),
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              child: Image.network(_photoUrls[i],
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => setState(() => _photoUrls.removeAt(i)),
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_photoUrls.length < 5)
                        MediaUploader(
                          key: ValueKey('add_tile_${_photoUrls.length}'),
                          folder: 'destinations',
                          width: 100,
                          height: 100,
                          onUploaded: (url) => setState(() => _photoUrls.add(url)),
                        ),
                    ],
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
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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

  Widget _sectionTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(text, style: AppTextStyles.heading3),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Text(text, style: AppTextStyles.label),
  );
}