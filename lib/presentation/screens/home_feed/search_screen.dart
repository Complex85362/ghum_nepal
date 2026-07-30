import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/max_width_box.dart';
import '../../../data/models/destination_model.dart';
import '../../../data/repositories/destination_repository.dart';
import '../../widgets/app_top_nav.dart';
import '../destination_detail/destination_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repository = DestinationRepository();
  final _controller = TextEditingController();
  List<DestinationModel> _results = [];
  bool _loading = false;
  String? _error;
  bool _searched = false;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _searched = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _searched = true;
    });
    try {
      final results = await _repository.search(query.trim());
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Search failed. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final hPad = isMobile ? AppSpacing.md : AppSpacing.xl;

    return Scaffold(
      appBar: const AppTopNav(),
      body: MaxWidthBox(
        maxWidth: 900,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: _search,
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _search(_controller.text),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (_loading)
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              else if (_error != null)
                Center(child: Text(_error!, style: const TextStyle(color: AppColors.error)))
              else if (_searched && _results.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: Text('No destinations found.'),
                    ),
                  )
                else if (_results.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        itemCount: _results.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : 3,
                          crossAxisSpacing: AppSpacing.lg,
                          mainAxisSpacing: AppSpacing.lg,
                          childAspectRatio: isMobile ? 2.5 : 1,
                        ),
                        itemBuilder: (context, index) {
                          final d = _results[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(AppSpacing.sm),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(d.coverImageUrl,
                                    width: 56, height: 56, fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        Container(width: 56, height: 56, color: AppColors.divider)),
                              ),
                              title: Text(d.name, style: AppTextStyles.label),
                              subtitle: Text(d.shortDescription,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DestinationDetailScreen(destinationId: d.id),
                                ),
                              ),
                            ),
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