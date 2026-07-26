import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedDestinations() async {
  final firestore = FirebaseFirestore.instance;

  final categories = [
    {'name': 'Hikes', 'slug': 'hikes', 'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306'},
    {'name': 'Lakes', 'slug': 'lakes', 'coverImageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4'},
    {'name': 'Temples & Cultural Sites', 'slug': 'temples', 'coverImageUrl': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf'},
    {'name': 'Viewpoints', 'slug': 'viewpoints', 'coverImageUrl': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa'},
  ];

  final categoryIds = <String, String>{};
  for (final c in categories) {
    final doc = await firestore.collection('categories').add(c);
    categoryIds[c['slug']!] = doc.id;
  }

  final destinations = [
    {
      'name': 'Shivapuri Hike',
      'categoryId': categoryIds['hikes'],
      'categoryName': 'Hikes',
      'province': 'Bagmati',
      'shortDescription': 'Enjoy the hike around Shivapuri',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean pretium finibus ex, quis commodo nulla ullamcorper nec.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'galleryImageUrls': ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4'],
      'latitude': 27.8167, 'longitude': 85.3667,
      'difficulty': 'Moderate', 'estimatedBudgetNpr': 1500,
      'averageRating': 4.5, 'reviewCount': 3,
      'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Lorem Ipsum Trail',
      'categoryId': categoryIds['hikes'],
      'categoryName': 'Hikes',
      'province': 'Gandaki',
      'shortDescription': 'Enjoy the hike around Shivapuri',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'galleryImageUrls': [],
      'latitude': 28.2096, 'longitude': 83.9856,
      'difficulty': 'Easy', 'estimatedBudgetNpr': 800,
      'averageRating': 4.0, 'reviewCount': 2,
      'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Phewa Lake',
      'categoryId': categoryIds['lakes'],
      'categoryName': 'Lakes',
      'province': 'Gandaki',
      'shortDescription': 'Boating and sunrise views over Phewa Lake',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      'galleryImageUrls': [],
      'latitude': 28.2096, 'longitude': 83.9310,
      'difficulty': 'Easy', 'estimatedBudgetNpr': 300,
      'averageRating': 4.6, 'reviewCount': 4,
      'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Rara Lake',
      'categoryId': categoryIds['lakes'],
      'categoryName': 'Lakes',
      'province': 'Karnali',
      'shortDescription': 'Nepal\'s largest and most remote lake',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      'galleryImageUrls': [],
      'latitude': 29.5330, 'longitude': 82.0800,
      'difficulty': 'Hard', 'estimatedBudgetNpr': 5000,
      'averageRating': 4.9, 'reviewCount': 1,
      'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Swayambhunath Temple',
      'categoryId': categoryIds['temples'],
      'categoryName': 'Temples & Cultural Sites',
      'province': 'Bagmati',
      'shortDescription': 'The iconic Monkey Temple overlooking Kathmandu',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf',
      'galleryImageUrls': [],
      'latitude': 27.7149, 'longitude': 85.2903,
      'difficulty': 'Easy', 'estimatedBudgetNpr': 200,
      'averageRating': 4.7, 'reviewCount': 6,
      'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Pashupatinath Temple',
      'categoryId': categoryIds['temples'],
      'categoryName': 'Temples & Cultural Sites',
      'province': 'Bagmati',
      'shortDescription': 'Sacred Hindu temple complex on the Bagmati river',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf',
      'galleryImageUrls': [],
      'latitude': 27.7106, 'longitude': 85.3487,
      'difficulty': 'Easy', 'estimatedBudgetNpr': 200,
      'averageRating': 4.8, 'reviewCount': 5,
      'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Phewa Lake Viewpoint',
      'categoryId': categoryIds['viewpoints'],
      'categoryName': 'Viewpoints',
      'province': 'Gandaki',
      'shortDescription': 'Sunrise views over Phewa Lake and the Annapurna range',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
      'galleryImageUrls': [],
      'latitude': 28.2096, 'longitude': 83.9310,
      'difficulty': 'Easy', 'estimatedBudgetNpr': 300,
      'averageRating': 4.6, 'reviewCount': 4,
      'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nagarkot Viewpoint',
      'categoryId': categoryIds['viewpoints'],
      'categoryName': 'Viewpoints',
      'province': 'Bagmati',
      'shortDescription': 'Panoramic Himalayan sunrise views near Kathmandu',
      'overview': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
      'galleryImageUrls': [],
      'latitude': 27.7172, 'longitude': 85.5206,
      'difficulty': 'Easy', 'estimatedBudgetNpr': 1000,
      'averageRating': 4.4, 'reviewCount': 3,
      'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  final destIds = <String>[];
  for (final d in destinations) {
    final doc = await firestore.collection('destinations').add(d);
    destIds.add(doc.id);
  }

  final reviews = [
    {'reviewerName': 'Anish', 'rating': 5, 'comment': 'Lorem Impsum dolor sit amet, consectetur adipiscing elit'},
    {'reviewerName': 'Sabina', 'rating': 4, 'comment': 'Lorem Impsum dolor sit amet, consectetur adipiscing elit'},
  ];
  for (final r in reviews) {
    await firestore.collection('reviews').add({
      ...r,
      'destinationId': destIds.first,
      'userId': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}