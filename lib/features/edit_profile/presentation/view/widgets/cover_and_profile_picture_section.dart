import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:tribe_up/features/edit_profile/presentation/view_model/edit_profile_intents.dart';
import 'package:tribe_up/features/edit_profile/presentation/view_model/edit_profile_states.dart';

class CoverAndProfilePictureSection extends StatefulWidget {
  const CoverAndProfilePictureSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  final EditProfileStates state;
  final EditProfileCubit cubit;

  @override
  State<CoverAndProfilePictureSection> createState() =>
      _CoverAndProfilePictureSectionState();
}

class _CoverAndProfilePictureSectionState
    extends State<CoverAndProfilePictureSection> {
  final ImagePicker _imagePicker = ImagePicker();

  // Helper to ignore backend default images so our beautiful UI can show up
  bool _isValidImage(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final lowerUrl = url.toLowerCase();

    // Ignore common default avatar strings from backend APIs
    if (lowerUrl.contains('default') ||
        lowerUrl.contains('placeholder') ||
        lowerUrl.contains('null') ||
        lowerUrl.contains('empty')) {
      return false;
    }
    return true;
  }

  Future<void> _pickImage(bool isCover) async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      final file = File(pickedImage.path);
      if (isCover) {
        widget.cubit.doIntent(UploadCoverIntent(file: file));
      } else {
        widget.cubit.doIntent(UploadProfilePictureIntent(file: file));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorManager.lightGrey.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_isValidImage(widget.state.data?.coverPicture))
                    ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: widget.state.data!.coverPicture!,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.black.withValues(alpha: 0.7),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorManager.white,
                            ColorManager.lightGrey.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _pickImage(true),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: ColorManager.grey.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorManager.transparent,
                          ColorManager.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  if (widget.state.isUploadingCover)
                    Container(
                      color: ColorManager.white.withValues(alpha: 0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        _CircularActionButton(
                          icon: Icons.camera_alt,
                          onPressed: () => _pickImage(true),
                        ),
                        if (widget.state.data?.coverPicture?.isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: _CircularActionButton(
                              icon: Icons.delete,
                              color: Colors.redAccent,
                              onPressed: () =>
                                  widget.cubit.doIntent(RemoveCoverIntent()),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Profile Section ---
          Positioned(
            left: 15,
            bottom: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Skeleton.replace(
                  replacement: const SizedBox(
                    width: 120,
                    height: 120,
                    child: Bone.circle(size: 120),
                  ),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.state.isLoading
                            ? ColorManager.lightGrey.withValues(alpha: 0.5)
                            : ColorManager.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        child: _isValidImage(widget.state.data?.profilePicture)
                            ? CachedNetworkImage(
                                imageUrl: widget.state.data!.profilePicture!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      ColorManager.lightGrey.withValues(
                                        alpha: 0.5,
                                      ),
                                      ColorManager.grey.withValues(alpha: 0.5),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: ColorManager.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                if (widget.state.isUploadingPicture)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorManager.lightGrey.withValues(alpha: 0.5),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: -4,
                  bottom: 8,
                  child: Column(
                    children: [
                      _CircularActionButton(
                        icon: Icons.camera_alt,
                        size: 34,
                        iconSize: 18,
                        onPressed: () => _pickImage(false),
                      ),
                      if (widget.state.data?.profilePicture?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: _CircularActionButton(
                            icon: Icons.delete,
                            size: 34,
                            iconSize: 18,
                            color: Colors.redAccent,
                            onPressed: () => widget.cubit.doIntent(
                              RemoveProfilePictureIntent(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? color;

  const _CircularActionButton({
    required this.icon,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton.ignore(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: iconSize, color: color ?? ColorManager.black),
        ),
      ),
    );
  }
}
