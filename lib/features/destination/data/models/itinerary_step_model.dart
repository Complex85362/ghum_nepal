import '../../domain/entities/itinerary_step_entity.dart';

class ItineraryStepModel extends ItineraryStepEntity {
  const ItineraryStepModel({
    required super.title,
    required super.description,
  });

  factory ItineraryStepModel.fromMap(Map<String, dynamic> map) {
    return ItineraryStepModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory ItineraryStepModel.fromEntity(ItineraryStepEntity entity) {
    return ItineraryStepModel(
      title: entity.title,
      description: entity.description,
    );
  }
}