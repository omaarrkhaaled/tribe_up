import 'dart:io';

import 'package:tribe_up/core/enums/settings_tab.dart';

sealed class TribeSettingsIntents {
  const TribeSettingsIntents();
}

final class SwitchSettingsTabIntent extends TribeSettingsIntents {
  final SettingsTab tab;
  const SwitchSettingsTabIntent(this.tab);
}

final class LoadMembersIntent extends TribeSettingsIntents {
  final int groupId;
  const LoadMembersIntent(this.groupId);
}

final class LoadMoreMembersIntent extends TribeSettingsIntents {
  final int groupId;
  const LoadMoreMembersIntent(this.groupId);
}

final class LoadFollowersIntent extends TribeSettingsIntents {
  final int groupId;
  const LoadFollowersIntent(this.groupId);
}

final class LoadMoreFollowersIntent extends TribeSettingsIntents {
  final int groupId;
  const LoadMoreFollowersIntent(this.groupId);
}

final class SaveGeneralSettingsIntent extends TribeSettingsIntents {
  final int groupId;
  final String groupName;
  final String description;
  final int accessibility; // 0=public, 1=private
  const SaveGeneralSettingsIntent({
    required this.groupId,
    required this.groupName,
    required this.description,
    required this.accessibility,
  });
}

final class UpdateTribePictureIntent extends TribeSettingsIntents {
  final int groupId;
  final File file;
  const UpdateTribePictureIntent(this.groupId, this.file);
}

final class DeleteTribePictureIntent extends TribeSettingsIntents {
  final int groupId;
  const DeleteTribePictureIntent(this.groupId);
}

final class PromoteMemberIntent extends TribeSettingsIntents {
  final int groupId;
  final int memberId;
  const PromoteMemberIntent(this.groupId, this.memberId);
}

final class DemoteMemberIntent extends TribeSettingsIntents {
  final int groupId;
  final int memberId;
  const DemoteMemberIntent(this.groupId, this.memberId);
}

final class KickMemberIntent extends TribeSettingsIntents {
  final int groupId;
  final int memberId;
  const KickMemberIntent(this.groupId, this.memberId);
}

final class DeleteFollowerIntent extends TribeSettingsIntents {
  final int groupId;
  final String followerId;
  const DeleteFollowerIntent(this.groupId, this.followerId);
}

final class DeleteTribeIntent extends TribeSettingsIntents {
  final int groupId;
  const DeleteTribeIntent(this.groupId);
}
