class DestinationModel {
  final String id;
  final String name;
  final String category; // hikes, food, viewpoints, lakes, cities, temples
  final String province;
  final String shortDescription;
  final String overview;
  final String details;
  final String coverImageUrl;
  final List<String> galleryImageUrls;
  final double latitude;
  final double longitude;
  final String difficulty; // Easy, Moderate, Hard
  final int estimatedBudgetNpr;
  final double averageRating;
  final int reviewCount;
  final bool isFeatured;
  final DateTime createdAt;

  DestinationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.province,
    required this.shortDescription,
    required this.overview,
    required this.details,
    required this.coverImageUrl,
    required this.galleryImageUrls,
    required this.latitude,
    required this.longitude,
    required this.difficulty,
    required this.estimatedBudgetNpr,
    required this.averageRating,
    required this.reviewCount,
    required this.isFeatured,
    required this.createdAt,
  });

  factory DestinationModel.fromMap(Map<String, dynamic> map, String id) {
    return DestinationModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      province: map['province'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      overview: map['overview'] ?? '',
      details: map['details'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      galleryImageUrls: List<String>.from(map['galleryImageUrls'] ?? []),
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      difficulty: map['difficulty'] ?? 'Easy',
      estimatedBudgetNpr: map['estimatedBudgetNpr'] ?? 0,
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      isFeatured: map['isFeatured'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'province': province,
      'shortDescription': shortDescription,
      'overview': overview,
      'details': details,
      'coverImageUrl': coverImageUrl,
      'galleryImageUrls': galleryImageUrls,
      'latitude': latitude,
      'longitude': longitude,
      'difficulty': difficulty,
      'estimatedBudgetNpr': estimatedBudgetNpr,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}