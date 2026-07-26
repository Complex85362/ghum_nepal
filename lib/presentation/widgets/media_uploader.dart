import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class MediaUploader extends StatefulWidget {
  final String folder;
  final String? initialUrl;
  final ValueChanged<String> onUploaded;

  const MediaUploader({
    super.key,
    required this.folder,
    required this.onUploaded,
    this.initialUrl,
  });

  @override
  State<MediaUploader> createState() => _MediaUploaderState();
}

class _MediaUploaderState extends State<MediaUploader> {
  String? _previewUrl;
  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _previewUrl = widget.initialUrl;
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() {
      _uploading = true;
      _error = null;
    });

    try {
      final bytes = await picked.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final path = '${widget.folder}/$fileName';

      await Supabase.instance.client.storage
          .from('media')
          .uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: true));

      final publicUrl = Supabase.instance.client.storage.from('media').getPublicUrl(path);

      setState(() {
        _previewUrl = publicUrl;
        _uploading = false;
      });
      widget.onUploaded(publicUrl);
    } catch (_) {
      setState(() {
        _error = 'Upload failed. Please try again.';
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _uploading ? null : _pickAndUpload,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              image: _previewUrl != null
                  ? DecorationImage(image: NetworkImage(_previewUrl!), fit: BoxFit.cover)
                  : null,
            ),
            child: _uploading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _previewUrl == null
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: AppColors.primary, size: 32),
                  SizedBox(height: AppSpacing.xs),
                  Text('Tap to upload image',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
                : Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 14, color: Colors.white),
                    onPressed: _uploading ? null : _pickAndUpload,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
        ],
      ],
    );
  }
}