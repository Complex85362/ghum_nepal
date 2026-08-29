import '../../domain/entities/wishlist_item_entity.dart';

class WishlistItemModel extends WishlistItemEntity {
  const WishlistItemModel({
    required super.destinationId,
    required super.name,
    required super.coverImageUrl,
    required super.categoryName,
    required super.addedAt,
  });

  factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
    return WishlistItemModel(
      destinationId: map['destinationId'] ?? '',
      name: map['name'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      categoryName: map['categoryName'] ?? '',
      addedAt: map['addedAt'] != null
          ? DateTime.parse(map['addedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destinationId': destinationId,
      'name': name,
      'coverImageUrl': coverImageUrl,
      'categoryName': categoryName,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}