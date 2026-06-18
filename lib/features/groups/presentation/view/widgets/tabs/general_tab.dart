import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/setting_privacy_option.dart';

class GeneralTab extends StatelessWidget {
  final Group tribe;
  final bool isOwner;
  final TextEditingController nameController;
  final TextEditingController descController;
  final int selectedAccessibility;
  final bool isSaving;
  final bool isUpdatingPicture;
  final ScrollController scrollController;
  final ValueChanged<int> onAccessibilityChanged;
  final VoidCallback onSave;
  final VoidCallback onPickPicture;
  final VoidCallback onDeletePicture;
  final VoidCallback onDeleteTribe;

  final String? coverPictureUrl;
  final bool coverPictureUrlIsSet;

  final File? localPickedFile;

  const GeneralTab({
    super.key,
    required this.tribe,
    required this.isOwner,
    required this.nameController,
    required this.descController,
    required this.selectedAccessibility,
    required this.isSaving,
    required this.isUpdatingPicture,
    required this.scrollController,
    required this.onAccessibilityChanged,
    required this.onSave,
    required this.onPickPicture,
    required this.onDeletePicture,
    required this.onDeleteTribe,
    this.coverPictureUrl,
    this.coverPictureUrlIsSet = false,
    this.localPickedFile,
  });

  @override
  Widget build(BuildContext context) {
    final String? rawUrl = coverPictureUrlIsSet
        ? coverPictureUrl
        : tribe.groupProfilePicture;
    final String? effectiveCoverUrl =
        (rawUrl != null &&
            rawUrl.trim().isNotEmpty &&
            rawUrl != 'null' &&
            rawUrl != 'undefined' &&
            rawUrl.startsWith('http'))
        ? rawUrl
        : null;
    final bool hasCover = localPickedFile != null || effectiveCoverUrl != null;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: localPickedFile != null
                  ? Image.file(
                      localPickedFile!,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : effectiveCoverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: effectiveCoverUrl,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 170,
                        width: double.infinity,
                        color: ColorManager.primary.withValues(alpha: 0.15),
                        child: Icon(
                          Icons.groups_outlined,
                          size: 110,
                          color: ColorManager.primary.withValues(alpha: 0.4),
                        ),
                      ),
                    )
                  : Container(
                      height: 170,
                      width: double.infinity,
                      color: ColorManager.primary.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.groups_outlined,
                        size: 110,
                        color: ColorManager.primary.withValues(alpha: 0.4),
                      ),
                    ),
            ),
            if (hasCover)
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: onDeletePicture,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorManager.red.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: ColorManager.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: onPickPicture,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: UiConstants.tribeName),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: descController,
          maxLines: 2,
          decoration: const InputDecoration(labelText: UiConstants.description),
        ),
        const SizedBox(height: 20),

        Text(
          UiConstants.privacy,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SettingPrivacyOption(
          icon: Icons.public,
          title: UiConstants.publicCapital,
          subtitle: UiConstants.publicSubtitle,
          isSelected: selectedAccessibility == 0,
          onTap: () => onAccessibilityChanged(0),
        ),
        const SizedBox(height: 10),
        SettingPrivacyOption(
          icon: Icons.lock_outline,
          title: UiConstants.privateCapital,
          subtitle: UiConstants.privateSubtitle,
          isSelected: selectedAccessibility == 1,
          onTap: () => onAccessibilityChanged(1),
        ),
        const SizedBox(height: 28),

        // Save button
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSaving ? null : onSave,
            child: isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    UiConstants.saveChanges,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),

        if (isOwner)
          SizedBox(
            height: 50,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onDeleteTribe,
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorManager.red,
                side: BorderSide(color: ColorManager.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(UiConstants.deleteTribe),
            ),
          ),
      ],
    );
  }
}
