import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_states.dart';

class ProfileCoverAndPicture extends StatelessWidget {
  final ProfileStates state;

  const ProfileCoverAndPicture({super.key, required this.state});

  bool _isValidImage(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('default') ||
        lowerUrl.contains('placeholder') ||
        lowerUrl.contains('null') ||
        lowerUrl.contains('empty')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorManager.lightGrey.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: _isValidImage(state.profile?.coverPicture)
                  ? CachedNetworkImage(
                      imageUrl: state.profile!.coverPicture!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorManager.white,
                            ColorManager.lightGrey.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 0,
            child: Skeleton.replace(
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
                    color: state.isLoadingProfile
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
                  child: _isValidImage(state.profile?.profilePicture)
                      ? CachedNetworkImage(
                          imageUrl: state.profile!.profilePicture,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorManager.lightGrey.withValues(alpha: 0.5),
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
        ],
      ),
    );
  }
}
