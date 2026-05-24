import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
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
                  'Tribe not found',
                  style: TextStyle(color: ColorManager.grey),
                ),
              ),
            );
          }
          return TribeProfileView(
            tribe: tribe,
            state: state,
            cubit: _cubit,
            userProfilePicture: _currentUser?.profilePicture,
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
        Navigator.pop(context, didChangeTribe);
      case OpenSettingsSheetUiIntent(:final tribe):
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TribeSettingsSheet(
            tribe: tribe,
            onSettingsSaved: () {
              cubit.doIntent(RefreshTribeIntent(tribe.id!));
            },
            onTribeDeleted: () {
              Navigator.pop(context); // close settings
              Navigator.pop(context, true); // go back to tribes list
            },
          ),
        );
      case OpenInviteSheetUiIntent():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invite coming soon!')));
      case ShowErrorUiIntent(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: ColorManager.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      case ShowSuccessUiIntent(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }
}
