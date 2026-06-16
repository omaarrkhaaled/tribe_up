import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/dialogs/edit_post_components/edit_post_caption_field.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/dialogs/edit_post_components/edit_post_existing_media.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/dialogs/edit_post_components/edit_post_new_media.dart';

class EditPostSheet extends StatefulWidget {
  final PostEntity post;
  final void Function(
    String caption,
    List<File>? newMediaFiles,
    List<int>? deleteMediaIds,
  )
  onSubmit;

  const EditPostSheet({super.key, required this.post, required this.onSubmit});

  @override
  State<EditPostSheet> createState() => _EditPostSheetState();
}

class _EditPostSheetState extends State<EditPostSheet> {
  late final TextEditingController _captionController;
  final List<File> _newFiles = [];
  final List<int> _deletedMediaIndices = [];

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption ?? '');
    _captionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _newFiles.add(File(picked.path)));
    }
  }

  bool get _hasChanges =>
      _captionController.text.trim() != (widget.post.caption ?? '').trim() ||
      _newFiles.isNotEmpty ||
      _deletedMediaIndices.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorManager.lightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(UiConstants.editPost, style: textTheme.titleLarge),
                  const SizedBox(width: 48),
                ],
              ),
              Divider(color: ColorManager.lightGrey.withValues(alpha: 0.3)),
              const SizedBox(height: 12),

              EditPostCaptionField(controller: _captionController),
              const SizedBox(height: 16),

              EditPostExistingMedia(
                media: widget.post.media,
                deletedIndices: _deletedMediaIndices,
                onDelete: (index) {
                  setState(() => _deletedMediaIndices.add(index));
                },
              ),
              if (widget.post.media.isNotEmpty &&
                  _deletedMediaIndices.length != widget.post.media.length)
                const SizedBox(height: 16),

              EditPostNewMedia(
                newFiles: _newFiles,
                onDelete: (index) {
                  setState(() => _newFiles.removeAt(index));
                },
              ),
              if (_newFiles.isNotEmpty) const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGrey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: ColorManager.black,
                      ),
                      const SizedBox(width: 8),
                      Text(UiConstants.addImage, style: textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (!_hasChanges)
                      ? null
                      : () {
                          widget.onSubmit(
                            _captionController.text.trim(),
                            _newFiles.isEmpty ? null : _newFiles,
                            _deletedMediaIndices.isEmpty
                                ? null
                                : _deletedMediaIndices
                                      .map((i) => widget.post.media[i].id)
                                      .whereType<int>()
                                      .toList(),
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    UiConstants.save,
                    style: textTheme.titleMedium!.copyWith(
                      color: ColorManager.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
