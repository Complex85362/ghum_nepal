import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_nav.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/max_width_box.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/destination_entity.dart';
import '../../domain/usecases/search_destinations_usecase.dart';

import 'destination_detail_screen.dart';
import '../../../../core/widgets/app_sidebar.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchDestinationsUseCase _searchUseCase;
  final _controller = TextEditingController();
  List<DestinationEntity> _results = [];
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
    final result = await _searchUseCase(SearchDestinationsParams(query.trim()));
    switch (result) {
      case Success<List<DestinationEntity>>(:final data):
        setState(() {
          _results = data;
          _loading = false;
        });
      case Error<List<DestinationEntity>>(:final failure):
        setState(() {
          _error = failure.message;
          _loading = false;
        });
    }
  }
  @override
  void initState() {
    super.initState();
    _searchUseCase = context.read<SearchDestinationsUseCase>();
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
      drawer: const AppSidebar(),
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
                      child: ListView.separated(
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
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
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
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