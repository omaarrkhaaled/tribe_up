import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/invite_members/active_invitation_card.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/invite_members/create_invite_button.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/invite_members/expiry_date_picker.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/invite_members/max_uses_field.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_state.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_ui_intents.dart';

class InviteMembersSheet extends StatefulWidget {
  final int groupId;

  const InviteMembersSheet({super.key, required this.groupId});

  @override
  State<InviteMembersSheet> createState() => _InviteMembersSheetState();
}

class _InviteMembersSheetState extends State<InviteMembersSheet> {
  late final InviteCubit _cubit;
  late final TextEditingController _maxUsesController;
  StreamSubscription<InviteUiIntents>? _uiSub;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<InviteCubit>();
    _maxUsesController = TextEditingController();
    _uiSub = _cubit.uiIntents.listen(_handleUiIntent);
    _cubit.doIntent(LoadActiveInvitationIntent(widget.groupId));
  }

  void _handleUiIntent(InviteUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case ShowSuccessUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.primary,
        );
      case ShowErrorUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
        );
      case CopyLinkUiIntent(:final url):
        Clipboard.setData(ClipboardData(text: url));
        UIUtils.showPremiumMessage(
          context,
          UiConstants.inviteLinkCopied,
          backgroundColor: ColorManager.primary,
          icon: Icons.check_circle_outline,
        );
    }
  }

  @override
  void dispose() {
    _uiSub?.cancel();
    _maxUsesController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: ColorManager.primary,
            onPrimary: ColorManager.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _create() {
    final maxUsesText = _maxUsesController.text.trim();
    final maxUses = maxUsesText.isEmpty ? null : int.tryParse(maxUsesText);
    String? expiresAt;
    if (_selectedDate != null) {
      expiresAt = _selectedDate!.toIso8601String();
    }
    _cubit.doIntent(
      CreateInvitationIntent(
        groupId: widget.groupId,
        expiresAt: expiresAt,
        maxUses: maxUses,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<InviteCubit, InviteState>(
        builder: (context, state) {
          final hasActive =
              state.hasActiveInvitation && state.activeInvitation != null;

          return Container(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        UiConstants.inviteMembers,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: ColorManager.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ExpiryDatePicker(
                    selectedDate: _selectedDate,
                    enabled: !hasActive,
                    onTap: hasActive ? null : _pickDate,
                  ),
                  const SizedBox(height: 16),

                  MaxUsesField(
                    controller: _maxUsesController,
                    enabled: !hasActive,
                  ),
                  const SizedBox(height: 20),

                  CreateInviteButton(
                    isCreating: state.isCreating,
                    onPressed:
                        hasActive || state.isCreating || state.isLoadingActive
                        ? null
                        : _create,
                  ),

                  if (state.isLoadingActive) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    ),
                  ] else if (hasActive) ...[
                    ActiveInvitationCard(
                      invitation: state.activeInvitation!,
                      isRevoking: state.isRevoking,
                      onRevoke: () => _cubit.doIntent(
                        RevokeInvitationIntent(state.activeInvitation!.id!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
