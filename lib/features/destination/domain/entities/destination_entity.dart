import 'itinerary_step_entity.dart';

class DestinationEntity {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String province;
  final String shortDescription;
  final String overview;
  final String details;
  final String coverImageUrl;
  final List<String> galleryImageUrls;
  final double latitude;
  final double longitude;
  final String difficulty;
  final int estimatedBudgetNpr;
  final double averageRating;
  final int reviewCount;
  final bool isFeatured;
  final bool approved;
  final String submittedBy;
  final DateTime createdAt;

  final int? altitude;
  final String bestTimeToVisit;
  final List<String> tags;
  final List<ItineraryStepEntity> itinerarySteps;

  const DestinationEntity({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
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
    required this.approved,
    required this.submittedBy,
    required this.createdAt,
    this.altitude,
    this.bestTimeToVisit = '',
    this.tags = const [],
    this.itinerarySteps = const [],
  });
}