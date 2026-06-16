class MediaEntity {
  final int? id;
  final String mediaURL;
  final String mediaType;
  final int order;

  const MediaEntity({
    this.id,
    required this.mediaURL,
    required this.mediaType,
    required this.order,
  });
}
