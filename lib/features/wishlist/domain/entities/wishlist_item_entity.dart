class WishlistItemEntity {
  final String destinationId;
  final String name;
  final String coverImageUrl;
  final String categoryName;
  final DateTime addedAt;

  const WishlistItemEntity({
    required this.destinationId,
    required this.name,
    required this.coverImageUrl,
    required this.categoryName,
    required this.addedAt,
  });
}