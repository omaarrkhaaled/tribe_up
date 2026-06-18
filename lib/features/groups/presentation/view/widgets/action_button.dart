import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/user_relation.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/dialogs/confirm_leave_dialog.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_states.dart';

class ActionButton extends StatefulWidget {
  final TribeProfileState state;
  final TribeProfileCubit cubit;
  final UserRelation relation;
  final Group tribe;

  const ActionButton({
    super.key,
    required this.state,
    required this.cubit,
    required this.relation,
    required this.tribe,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.isActionLoading) {
      return SizedBox(
        width: 80,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primary,
            ),
          ),
        ),
      );
    }

    switch (widget.relation) {
      case UserRelation.none:
      case UserRelation.follower:
        return ElevatedButton(
          onPressed: () => widget.cubit.doIntent(const ToggleFollowIntent()),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            widget.relation == UserRelation.none
                ? UiConstants.follow
                : UiConstants.following,
          ),
        );
      case UserRelation.member:
      case UserRelation.admin:
      case UserRelation.owner:
        return ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ConfirmLeaveDialog(
              tribeName: widget.tribe.groupName ?? '',
              onConfirm: () => widget.cubit.doIntent(LeaveGroupIntent()),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.grey,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            minimumSize: const Size(0, 36),
          ),
          child: const Text(UiConstants.joined),
        );
    }
  }
}
