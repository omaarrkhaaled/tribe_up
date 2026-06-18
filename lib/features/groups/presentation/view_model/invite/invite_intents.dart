sealed class InviteIntents {
  const InviteIntents();
}

final class LoadActiveInvitationIntent extends InviteIntents {
  final int groupId;
  const LoadActiveInvitationIntent(this.groupId);
}

final class CreateInvitationIntent extends InviteIntents {
  final int groupId;
  final String? expiresAt;
  final int? maxUses;
  const CreateInvitationIntent({
    required this.groupId,
    this.expiresAt,
    this.maxUses,
  });
}

final class RevokeInvitationIntent extends InviteIntents {
  final int invitationId;
  const RevokeInvitationIntent(this.invitationId);
}
