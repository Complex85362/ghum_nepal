import '../../domain/entities/destination_entity.dart';
import '../../domain/entities/itinerary_step_entity.dart';
import 'itinerary_step_model.dart';

class DestinationModel extends DestinationEntity {
  const DestinationModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.categoryName,
    required super.province,
    required super.shortDescription,
    required super.overview,
    required super.details,
    required super.coverImageUrl,
    required super.galleryImageUrls,
    required super.latitude,
    required super.longitude,
    required super.difficulty,
    required super.estimatedBudgetNpr,
    required super.averageRating,
    required super.reviewCount,
    required super.isFeatured,
    required super.approved,
    required super.submittedBy,
    required super.createdAt,
    super.altitude,
    super.bestTimeToVisit,
    super.tags,
    super.itinerarySteps,
  });

  factory DestinationModel.fromMap(Map<String, dynamic> map, String id) {
    return DestinationModel(
      id: id,
      name: map['name'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
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
      approved: map['approved'] ?? false,
      submittedBy: map['submittedBy'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      altitude: map['altitude'] as int?,
      bestTimeToVisit: map['bestTimeToVisit'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      itinerarySteps: (map['itinerarySteps'] as List<dynamic>? ?? [])
          .map((e) => ItineraryStepModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'categoryName': categoryName,
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
      'approved': approved,
      'submittedBy': submittedBy,
      'createdAt': createdAt.toIso8601String(),
      'altitude': altitude,
      'bestTimeToVisit': bestTimeToVisit,
      'tags': tags,
      'itinerarySteps': itinerarySteps
          .map((e) => ItineraryStepModel.fromEntity(e).toMap())
          .toList(),
    };
  }

  factory DestinationModel.fromEntity(DestinationEntity entity) {
    return DestinationModel(
      id: entity.id,
      name: entity.name,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      province: entity.province,
      shortDescription: entity.shortDescription,
      overview: entity.overview,
      details: entity.details,
      coverImageUrl: entity.coverImageUrl,
      galleryImageUrls: entity.galleryImageUrls,
      latitude: entity.latitude,
      longitude: entity.longitude,
      difficulty: entity.difficulty,
      estimatedBudgetNpr: entity.estimatedBudgetNpr,
      averageRating: entity.averageRating,
      reviewCount: entity.reviewCount,
      isFeatured: entity.isFeatured,
      approved: entity.approved,
      submittedBy: entity.submittedBy,
      createdAt: entity.createdAt,
      altitude: entity.altitude,
      bestTimeToVisit: entity.bestTimeToVisit,
      tags: entity.tags,
      itinerarySteps: entity.itinerarySteps,
    );
  }
}