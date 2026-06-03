import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/invite_members_sheet.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribe_profile_view.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribe_settings_sheet.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_ui_intents.dart';

class TribeProfileScreen extends StatefulWidget {
  final Group? group;
  final int? groupId;

  const TribeProfileScreen({super.key, this.group, this.groupId});

  @override
  State<TribeProfileScreen> createState() => _TribeProfileScreenState();
}

class _TribeProfileScreenState extends State<TribeProfileScreen> {
  late final TribeProfileCubit _cubit;
  late final StreamSubscription<TribeProfileUiIntents> _uiSubscription;
  UserSummaryEntity? _currentUser;
  bool _didChangeTribe = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TribeProfileCubit>();
    final id = widget.group?.id ?? widget.groupId!;
    _cubit.doIntent(LoadTribeIntent(id, initialGroup: widget.group));
    _uiSubscription = _cubit.uiIntents.listen((intent) {
      if (!mounted) return;
      _handleUiIntent(context, intent, _cubit);
    });
    _loadUser();
  }

  Future<void> _loadUser() async {
    final model = await getIt<LoginLocalDataSource>().getUserSummary();
    if (model != null && mounted) {
      setState(() {
        _currentUser = model.toEntity();
      });
    }
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TribeProfileCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<TribeProfileCubit, TribeProfileState>(
        builder: (context, state) {
          final tribe = state.tribe ?? widget.group;
          if (tribe == null && state.isLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            );
          }
          if (tribe == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(
                  UiConstants.tribeNotFound,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: ColorManager.grey),
                ),
              ),
            );
          }
          return TribeProfileView(
            tribe: tribe,
            state: state,
            cubit: _cubit,
            userProfilePicture: _currentUser?.profilePicture,
            didChangeTribe: _didChangeTribe,
          );
        },
      ),
    );
  }

  void _handleUiIntent(
    BuildContext context,
    TribeProfileUiIntents intent,
    TribeProfileCubit cubit,
  ) {
    switch (intent) {
      case NavigateBackUiIntent(:final didChangeTribe):
        Navigator.pop(context, _didChangeTribe || didChangeTribe);
      case OpenSettingsSheetUiIntent(:final tribe):
        final currentState = cubit.state;
        final isOwner = currentState.userRelation.isOwner;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => TribeSettingsSheet(
            tribe: tribe,
            isOwner: isOwner,
            onSettingsSaved: () {
              setState(() {
                _didChangeTribe = true;
              });
              cubit.doIntent(RefreshTribeIntent(tribe.id!));
            },
            onTribeDeleted: () {
              Navigator.pop(context, true);
            },
          ),
        );
      case OpenInviteSheetUiIntent(:final groupId):
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: ColorManager.transparent,
          builder: (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: InviteMembersSheet(groupId: groupId),
          ),
        );
      case ShowErrorUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
        );
      case ShowSuccessUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.primary,
        );
    }
  }
}
