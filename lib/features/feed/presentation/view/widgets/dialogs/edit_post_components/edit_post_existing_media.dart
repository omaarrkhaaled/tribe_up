import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/feed/data/models/media_model.dart';

class EditPostExistingMedia extends StatelessWidget {
  final List<MediaModel> media;
  final List<int> deletedIndices;
  final ValueChanged<int> onDelete;

  const EditPostExistingMedia({
    super.key,
    required this.media,
    required this.deletedIndices,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final existingMediaWithIndex = media
        .asMap()
        .entries
        .where((e) => !deletedIndices.contains(e.key))
        .toList();

    if (existingMediaWithIndex.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          UiConstants.existingMedia,
          style: textTheme.labelMedium?.copyWith(color: ColorManager.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: existingMediaWithIndex.length,
            itemBuilder: (_, i) {
              final originalIndex = existingMediaWithIndex[i].key;
              final m = existingMediaWithIndex[i].value;
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorManager.lightGrey.withValues(alpha: 0.3),
                      image: m.mediaType == 'Image'
                          ? DecorationImage(
                              image: NetworkImage(m.mediaURL),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: m.mediaType == 'Video'
                        ? const Icon(Icons.videocam_outlined, size: 32)
                        : null,
                  ),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => onDelete(originalIndex),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: ColorManager.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
