import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/groups/data/models/request/create_invitation_request.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_invitations/create_invitations_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_invitations/get_active_invitation_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_invitations/revoke_invitation_use_case.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_state.dart';
import 'package:tribe_up/features/groups/presentation/view_model/invite/invite_ui_intents.dart';

@injectable
class InviteCubit extends Cubit<InviteState> {
  final CreateInvitationsUseCase _createInvitationsUseCase;
  final GetActiveInvitationUseCase _getActiveInvitationUseCase;
  final RevokeInvitationUseCase _revokeInvitationUseCase;

  final StreamController<InviteUiIntents> _uiController =
      StreamController.broadcast();
  Stream<InviteUiIntents> get uiIntents => _uiController.stream;

  InviteCubit(
    this._createInvitationsUseCase,
    this._getActiveInvitationUseCase,
    this._revokeInvitationUseCase,
  ) : super(const InviteState());

  void doIntent(InviteIntents intent) {
    switch (intent) {
      case LoadActiveInvitationIntent(:final groupId):
        _loadActiveInvitation(groupId);
      case CreateInvitationIntent(
        :final groupId,
        :final expiresAt,
        :final maxUses,
      ):
        _createInvitation(groupId, expiresAt, maxUses);
      case RevokeInvitationIntent(:final invitationId):
        _revokeInvitation(invitationId);
    }
  }

  Future<void> _loadActiveInvitation(int groupId) async {
    emit(state.copyWith(isLoadingActive: true, clearError: true));
    final response = await _getActiveInvitationUseCase(groupId);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            isLoadingActive: false,
            activeInvitation: data,
            hasActiveInvitation: true,
          ),
        );
      case ErrorResponse():
        emit(
          state.copyWith(
            isLoadingActive: false,
            hasActiveInvitation: false,
            clearInvitation: true,
          ),
        );
    }
  }

  Future<void> _createInvitation(
    int groupId,
    String? expiresAt,
    int? maxUses,
  ) async {
    emit(state.copyWith(isCreating: true, clearError: true));
    final request = CreateInvitationRequest(
      expiresAt: expiresAt,
      maxUses: maxUses,
    );
    final response = await _createInvitationsUseCase(groupId, request);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            isCreating: false,
            activeInvitation: data,
            hasActiveInvitation: true,
          ),
        );
        _uiController.add(ShowSuccessUiIntent(UiConstants.invitationCreated));
      case ErrorResponse(:final error):
        emit(state.copyWith(isCreating: false, errorMessage: error.message));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _revokeInvitation(int invitationId) async {
    emit(state.copyWith(isRevoking: true, clearError: true));
    final response = await _revokeInvitationUseCase(invitationId);
    switch (response) {
      case SuccessResponse():
        emit(
          state.copyWith(
            isRevoking: false,
            hasActiveInvitation: false,
            clearInvitation: true,
          ),
        );
        _uiController.add(ShowSuccessUiIntent(UiConstants.invitationRevoked));
      case ErrorResponse(:final error):
        emit(state.copyWith(isRevoking: false, errorMessage: error.message));
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
