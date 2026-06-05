import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class EditPostNewMedia extends StatelessWidget {
  final List<File> newFiles;
  final ValueChanged<int> onDelete;

  const EditPostNewMedia({
    super.key,
    required this.newFiles,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (newFiles.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          UiConstants.newMediaToAdd,
          style: textTheme.labelMedium?.copyWith(color: ColorManager.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newFiles.length,
            itemBuilder: (_, i) {
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(newFiles[i]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => onDelete(i),
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
