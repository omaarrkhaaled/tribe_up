import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/groups/data/models/response/group_invitations_response.dart';

class InviteState extends Equatable {
  final bool isLoadingActive;
  final bool isCreating;
  final bool isRevoking;
  final InvitationResultDTO? activeInvitation;
  final bool hasActiveInvitation;
  final String? errorMessage;

  const InviteState({
    this.isLoadingActive = false,
    this.isCreating = false,
    this.isRevoking = false,
    this.activeInvitation,
    this.hasActiveInvitation = false,
    this.errorMessage,
  });

  InviteState copyWith({
    bool? isLoadingActive,
    bool? isCreating,
    bool? isRevoking,
    InvitationResultDTO? activeInvitation,
    bool? hasActiveInvitation,
    String? errorMessage,
    bool clearError = false,
    bool clearInvitation = false,
  }) {
    return InviteState(
      isLoadingActive: isLoadingActive ?? this.isLoadingActive,
      isCreating: isCreating ?? this.isCreating,
      isRevoking: isRevoking ?? this.isRevoking,
      activeInvitation: clearInvitation
          ? null
          : (activeInvitation ?? this.activeInvitation),
      hasActiveInvitation: hasActiveInvitation ?? this.hasActiveInvitation,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoadingActive,
    isCreating,
    isRevoking,
    activeInvitation,
    hasActiveInvitation,
    errorMessage,
  ];
}
