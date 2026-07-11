import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/enums/settings_tab.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/dialogs/confirm_delete_tribe_dialog.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/dialogs/confirm_remove_cover_dialog.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tabs/followers_tab.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tabs/general_tab.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tabs/members_tab.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/setting_tab_bar.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_ui_intents.dart';

class TribeSettingsSheet extends StatefulWidget {
  final Group tribe;
  final bool isOwner;
  final VoidCallback onSettingsSaved;
  final VoidCallback onTribeDeleted;

  const TribeSettingsSheet({
    super.key,
    required this.tribe,
    required this.isOwner,
    required this.onSettingsSaved,
    required this.onTribeDeleted,
  });

  @override
  State<TribeSettingsSheet> createState() => _TribeSettingsSheetState();
}

class _TribeSettingsSheetState extends State<TribeSettingsSheet> {
  late final TribeSettingsCubit _cubit;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late int _selectedAccessibility;
  StreamSubscription<TribeSettingsUiIntents>? _uiSub;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TribeSettingsCubit>();
    _nameController = TextEditingController(text: widget.tribe.groupName ?? '');
    _descController = TextEditingController(
      text: widget.tribe.description ?? '',
    );
    _selectedAccessibility = widget.tribe.accessibility ?? 0;

    _uiSub = _cubit.uiIntents.listen(_handleUiIntent);
  }

  void _handleUiIntent(TribeSettingsUiIntents intent) {
    switch (intent) {
      case TribeDeletedUiIntent():
        EasyLoading.dismiss();
        if (mounted) {
          Navigator.pop(context);
          widget.onTribeDeleted();
        }
      case SettingsSavedUiIntent():
        if (mounted) {
          Navigator.pop(context);
          widget.onSettingsSaved();
        }
      case ShowSuccessUiIntent(:final message):
        EasyLoading.showSuccess(message, duration: const Duration(seconds: 2));
      case ShowErrorUiIntent(:final message):
        EasyLoading.showError(message, duration: const Duration(seconds: 3));
    }
  }

  @override
  void dispose() {
    _uiSub?.cancel();
    _nameController.dispose();
    _descController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TribeSettingsCubit>.value(
      value: _cubit,
      child: BlocBuilder<TribeSettingsCubit, TribeSettingsState>(
        builder: (context, state) {
          final cubit = context.read<TribeSettingsCubit>();
          return DraggableScrollableSheet(
            initialChildSize: 0.92,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ColorManager.lightGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              UiConstants.setting,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    SettingTabBar(
                      currentTab: state.currentTab,
                      onTabSelected: (tab) {
                        cubit.doIntent(SwitchSettingsTabIntent(tab));
                        if (tab == SettingsTab.members &&
                            state.members.isEmpty) {
                          cubit.doIntent(LoadMembersIntent(widget.tribe.id!));
                        }
                        if (tab == SettingsTab.followers &&
                            state.followers.isEmpty) {
                          cubit.doIntent(LoadFollowersIntent(widget.tribe.id!));
                        }
                      },
                    ),

                    Expanded(
                      child: _buildTabContent(
                        context,
                        state,
                        cubit,
                        scrollController,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    TribeSettingsState state,
    TribeSettingsCubit cubit,
    ScrollController scrollController,
  ) {
    return switch (state.currentTab) {
      SettingsTab.general => GeneralTab(
        tribe: widget.tribe,
        isOwner: widget.isOwner,
        nameController: _nameController,
        descController: _descController,
        selectedAccessibility: _selectedAccessibility,
        isSaving: state.isSavingGeneral,
        isUpdatingPicture: state.isUpdatingPicture,
        scrollController: scrollController,
        coverPictureUrl: state.coverPictureUrl,
        coverPictureUrlIsSet: state.coverPictureUrlIsSet,
        localPickedFile: state.localPickedFile,
        onAccessibilityChanged: (val) =>
            setState(() => _selectedAccessibility = val),
        onSave: () => cubit.doIntent(
          SaveGeneralSettingsIntent(
            groupId: widget.tribe.id!,
            groupName: _nameController.text.trim(),
            description: _descController.text.trim(),
            accessibility: _selectedAccessibility,
          ),
        ),
        onPickPicture: () async {
          final picker = ImagePicker();
          final picked = await picker.pickImage(source: ImageSource.gallery);
          if (picked != null && context.mounted) {
            cubit.doIntent(
              UpdateTribePictureIntent(widget.tribe.id!, File(picked.path)),
            );
          }
        },
        onDeletePicture: () => showDialog(
          context: context,
          builder: (context) =>
              ConfirmRemoveCoverDialog(tribe: widget.tribe, cubit: cubit),
        ),
        onDeleteTribe: () => showDialog(
          context: context,
          builder: (context) =>
              ConfirmDeleteTribeDialog(tribe: widget.tribe, cubit: cubit),
        ),
      ),
      SettingsTab.members => MembersTab(
        state: state,
        groupId: widget.tribe.id!,
        cubit: cubit,
        isOwner: widget.isOwner,
        scrollController: scrollController,
      ),
      SettingsTab.followers => FollowersTab(
        state: state,
        groupId: widget.tribe.id!,
        cubit: cubit,
        scrollController: scrollController,
      ),
    };
  }
}
