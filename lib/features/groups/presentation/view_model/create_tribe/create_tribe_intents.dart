import 'dart:io';

sealed class CreateTribeIntents {
  const CreateTribeIntents();
}

final class CreateTribeIntent extends CreateTribeIntents {
  final String groupName;
  final String description;
  final int accessibility; // 0=public, 1=private
  final File? profilePicture;
  const CreateTribeIntent({
    required this.groupName,
    required this.description,
    required this.accessibility,
    this.profilePicture,
  });
}
