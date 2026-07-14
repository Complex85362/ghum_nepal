import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedDestinations() async {
  final firestore = FirebaseFirestore.instance;
  final destinations = [
    {
      'name': 'Shivapuri Hike',
      'category': 'hikes',
      'province': 'Bagmati',
      'shortDescription': 'Enjoy the hike around Shivapuri',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pretium finibus ex, quis commodo nulla ullamcorper nec.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pretium finibus ex, quis commodo nulla ullamcorper nec.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
      ],
      'latitude': 27.8167,
      'longitude': 85.3667,
      'difficulty': 'Moderate',
      'estimatedBudgetNpr': 1500,
      'averageRating': 4.5,
      'reviewCount': 3,
      'isFeatured': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Lorem Ipsum Trail',
      'category': 'hikes',
      'province': 'Gandaki',
      'shortDescription': 'Enjoy the hike around Shivapuri',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      ],
      'latitude': 28.2096,
      'longitude': 83.9856,
      'difficulty': 'Easy',
      'estimatedBudgetNpr': 800,
      'averageRating': 4.0,
      'reviewCount': 2,
      'isFeatured': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Momo Street Thamel',
      'category': 'food',
      'province': 'Bagmati',
      'shortDescription': 'Best local momo spots in Thamel',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
      'galleryImageUrls': [],
      'latitude': 27.7154,
      'longitude': 85.3123,
      'difficulty': 'Easy',
      'estimatedBudgetNpr': 500,
      'averageRating': 4.8,
      'reviewCount': 5,
      'isFeatured': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Phewa Lake Viewpoint',
      'category': 'viewpoints',
      'province': 'Gandaki',
      'shortDescription': 'Sunrise views over Phewa Lake',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      'galleryImageUrls': [],
      'latitude': 28.2096,
      'longitude': 83.9310,
      'difficulty': 'Easy',
      'estimatedBudgetNpr': 300,
      'averageRating': 4.6,
      'reviewCount': 4,
      'isFeatured': true,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  for (final d in destinations) {
    await firestore.collection('destinations').add(d);
  }

  final reviews = [
    {'reviewerName': 'Anish', 'rating': 5, 'comment': 'Lorem Impsum dolor sit amet, consectetur adipiscing elit'},
    {'reviewerName': 'Sabina', 'rating': 4, 'comment': 'Lorem Impsum dolor sit amet, consectetur adipiscing elit'},
  ];

  final firstDoc = await firestore.collection('destinations').limit(1).get();
  if (firstDoc.docs.isNotEmpty) {
    final destId = firstDoc.docs.first.id;
    for (final r in reviews) {
      await firestore.collection('reviews').add({
        ...r,
        'destinationId': destId,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }
}