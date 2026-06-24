import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/date_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/personal_posts.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/profile_cover_and_picture.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_states.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile_ui_intents.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';

class ProfileScreen extends StatefulWidget {
  final String? userName;

  const ProfileScreen({super.key, this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;
  late final StreamSubscription<ProfileUiIntents> _uiSubscription;
  String? _targetUserName;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>();
    _uiSubscription = _cubit.uiIntents.listen(_handleUiIntent);
    _initialize();
  }

  Future<void> _initialize() async {
    _targetUserName = widget.userName;
    if (_targetUserName == null) {
      final userSummary = await getIt<LoginLocalDataSource>().getUserSummary();
      _targetUserName = userSummary?.userName;
    }

    if (_targetUserName != null) {
      _cubit.doIntent(GetProfileDetailsIntent(userName: _targetUserName!));
      _cubit.doIntent(GetPersonalPostsIntent(userName: _targetUserName!));
    }
  }

  void _handleUiIntent(ProfileUiIntents intent) async {
    if (!mounted) return;
    switch (intent) {
      case ShowSuccessProfileIntent(:final message):
        UIUtils.showPremiumMessage(context, message);
        break;
      case ShowErrorProfileIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
          icon: Icons.error_outline_rounded,
        );
        break;
    }
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text(UiConstants.profile)),
        body: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state.profile == null && !state.isLoadingProfile) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(UiConstants.failedToLoadProfile),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _targetUserName != null
                          ? () => _cubit.doIntent(
                              GetProfileDetailsIntent(
                                userName: _targetUserName!,
                              ),
                            )
                          : null,
                      child: const Text(UiConstants.retry),
                    ),
                  ],
                ),
              );
            }

            return Skeletonizer(
              enabled: state.isLoadingProfile,
              effect: ShimmerEffect(
                baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
                highlightColor: ColorManager.white.withValues(alpha: 0.6),
                duration: const Duration(milliseconds: 1200),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileCoverAndPicture(state: state),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.profile?.fullName ?? BoneMock.fullName,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${state.profile?.userName ?? BoneMock.name}',
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                              color: ColorManager.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.profile?.bio ?? BoneMock.subtitle,
                            style: textTheme.headlineSmall?.copyWith(
                              fontSize: 18,
                              color: ColorManager.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: ColorManager.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.profile?.createdAt != null
                                    ? DateConstants.formatDate(
                                        state.profile!.createdAt,
                                      )
                                    : UiConstants.joinedRecently,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: ColorManager.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildStatItem(
                                state.profile?.tribesCount.toString() ?? '0',
                                UiConstants.tribes,
                              ),
                              const SizedBox(width: 24),
                              _buildStatItem(
                                state.profile?.postsCount.toString() ?? '0',
                                UiConstants.posts,
                              ),
                              const Spacer(),
                              if (state.profile?.isOwnProfile == true)
                                OutlinedButton(
                                  onPressed: () async {
                                    await context.pushNamed(
                                      AppRoutesConstants.editProfile,
                                    );
                                    if (_targetUserName != null && mounted) {
                                      _cubit.doIntent(
                                        GetProfileDetailsIntent(
                                          userName: _targetUserName!,
                                        ),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: state.isLoadingProfile
                                        ? ColorManager.transparent
                                        : ColorManager.black,
                                    side: state.isLoadingProfile
                                        ? BorderSide.none
                                        : BorderSide(
                                            color: ColorManager.lightGrey,
                                          ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    UiConstants.editProfile,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (state.profile?.isOwnProfile == false)
                                SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: ColorManager.lightGrey.withValues(alpha: 0.2),
                    ),
                    PersonalPosts(state: state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Row(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: ColorManager.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ColorManager.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
