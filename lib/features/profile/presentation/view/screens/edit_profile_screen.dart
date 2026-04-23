import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/change_password_section.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/cover_and_profile_picture_section.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/edit_bio_sheet.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/edit_name_sheet.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/edit_phone_sheet.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/section_card.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_states.dart';
import 'package:tribe_up/features/profile/presentation/view_model/edit_profile_ui_intents.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final EditProfileCubit _cubit;
  late final StreamSubscription<EditProfileUiIntents> _uiSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<EditProfileCubit>()..doIntent(GetProfileInfoIntent());
    _uiSubscription = _cubit.uiIntents.listen(_handleUiIntent);
  }

  void _handleUiIntent(EditProfileUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case ShowErrorIntent(:final errorMessage):
        UIUtils.showPremiumMessage(
          context,
          errorMessage,
          backgroundColor: ColorManager.red,
          icon: Icons.error_outline_rounded,
        );
      case ShowSuccessIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          icon: Icons.check_circle_outline_rounded,
        );
      case DismissDialogIntent():
        Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    _cubit.close();
    super.dispose();
  }

  void _showBottomSheet(Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.black,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: sheet,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(UiConstants.editProfile)),
        body: BlocBuilder<EditProfileCubit, EditProfileStates>(
          builder: (context, state) {
            if (state.data == null && !state.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(UiConstants.failedToLoadProfile),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.doIntent(GetProfileInfoIntent()),
                      child: const Text(UiConstants.retry),
                    ),
                  ],
                ),
              );
            }
            return Skeletonizer(
              enabled: state.isLoading,
              effect: ShimmerEffect(
                baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
                highlightColor: ColorManager.white.withValues(alpha: 0.6),
                duration: const Duration(milliseconds: 1200),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CoverAndProfilePictureSection(state: state, cubit: _cubit),
                    const SizedBox(height: 20),
                    Divider(
                      color: ColorManager.lightGrey.withValues(alpha: 0.2),
                    ),
                    SectionCard(
                      title: UiConstants.fullName,
                      value:
                          state.data?.firstName != null &&
                              state.data?.lastName != null
                          ? '${state.data!.firstName} ${state.data!.lastName}'
                          : UiConstants.loadingFullName,
                      onEdit: () =>
                          _showBottomSheet(EditNameSheet(cubit: _cubit)),
                    ),
                    SectionCard(
                      title: UiConstants.phoneNumber,
                      value: state.data?.phoneNumber?.isNotEmpty == true
                          ? state.data!.phoneNumber!
                          : (state.isLoading
                                ? UiConstants.loadingPhoneNumber
                                : UiConstants.noPhoneNumber),
                      onEdit: () =>
                          _showBottomSheet(EditPhoneSheet(cubit: _cubit)),
                      onRemove: state.data?.phoneNumber?.isNotEmpty == true
                          ? () => _cubit.doIntent(RemovePhoneNumberIntent())
                          : null,
                    ),
                    SectionCard(
                      title: UiConstants.bio,
                      value: state.data?.bio?.isNotEmpty == true
                          ? state.data!.bio!
                          : (state.isLoading
                                ? UiConstants.loadingBio
                                : UiConstants.noBio),
                      onEdit: () =>
                          _showBottomSheet(EditBioSheet(cubit: _cubit)),
                      onRemove: state.data?.bio?.isNotEmpty == true
                          ? () => _cubit.doIntent(RemoveBioIntent())
                          : null,
                    ),
                    const ChangePasswordSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
