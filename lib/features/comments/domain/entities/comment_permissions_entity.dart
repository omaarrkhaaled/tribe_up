class CommentPermissionsEntity {
  final bool? canDelete;
  final bool? canEdit;
  final bool? canModerate;

  const CommentPermissionsEntity({
    this.canDelete,
    this.canEdit,
    this.canModerate,
  });
}
