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
      'name': 'Shivapuri Hike', 'categoryId': categoryIds['hikes'], 'categoryName': 'Hikes',
      'province': 'Bagmati',
      'shortDescription': 'A forested day hike overlooking Kathmandu Valley',
      'overview': 'Shivapuri National Park sits just north of Kathmandu Valley and offers one of the most accessible yet rewarding day hikes near the capital. The trail winds through dense forests of oak, rhododendron, and pine before reaching the summit at 2,732 meters, where clear-day views stretch across the valley to the distant Himalayan range.',
      'details': 'The hike typically takes 5 to 6 hours round trip starting from Sundarijal or Budhanilkantha. An entry permit is required at the park gate. It is best to start early morning to avoid afternoon clouds. Sturdy hiking shoes are recommended, as sections of the trail can be steep and rocky, especially after rain.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'galleryImageUrls': ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4'],
      'latitude': 27.8167, 'longitude': 85.3667, 'difficulty': 'Moderate', 'estimatedBudgetNpr': 1500,
      'averageRating': 4.5, 'reviewCount': 3, 'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Champadevi Hill Trail', 'categoryId': categoryIds['hikes'], 'categoryName': 'Hikes',
      'province': 'Bagmati',
      'shortDescription': 'A quiet ridge walk on the edge of the valley',
      'overview': 'Champadevi is a lesser-known hill on the southwestern rim of Kathmandu Valley, popular with locals but largely overlooked by tourists. The trail passes through pine forest and small Tamang settlements before reaching a ridge with panoramic views of the valley on one side and the Annapurna and Ganesh Himal ranges on a clear day on the other.',
      'details': 'Starting from Hattiban, the round trip takes roughly 4 hours at a relaxed pace. The path is well-marked and suitable for beginners, though the final stretch to the summit is a steady uphill climb. Early morning starts offer the best visibility before haze sets in.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'galleryImageUrls': [],
      'latitude': 27.6412, 'longitude': 85.2661, 'difficulty': 'Easy', 'estimatedBudgetNpr': 800,
      'averageRating': 4.0, 'reviewCount': 2, 'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Phewa Lake', 'categoryId': categoryIds['lakes'], 'categoryName': 'Lakes',
      'province': 'Gandaki',
      'shortDescription': 'Pokhara\'s iconic lake with mirror-like Himalayan reflections',
      'overview': 'Phewa Lake is the second-largest lake in Nepal and the centerpiece of Pokhara\'s tourism, known for its still waters that reflect the Annapurna range on clear mornings. Small wooden boats ferry visitors across to the Tal Barahi Temple, a Hindu shrine built on an island near the eastern shore.',
      'details': 'Boat rentals are available along the lakeside promenade for a few hundred rupees per hour. Sunrise and sunset are the most popular times to visit for photography, when the water is calmest. The lakeside area also has cafes, shops, and paragliding landing points nearby.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      'galleryImageUrls': [],
      'latitude': 28.2096, 'longitude': 83.9310, 'difficulty': 'Easy', 'estimatedBudgetNpr': 300,
      'averageRating': 4.6, 'reviewCount': 4, 'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Rara Lake', 'categoryId': categoryIds['lakes'], 'categoryName': 'Lakes',
      'province': 'Karnali',
      'shortDescription': 'Nepal\'s largest and most remote high-altitude lake',
      'overview': 'Rara Lake sits at nearly 3,000 meters within Rara National Park in the far northwest of Nepal, one of the country\'s least visited yet most striking natural landmarks. Surrounded by pine and juniper forest, the deep blue lake changes color throughout the day and remains largely untouched by mass tourism due to its remote location.',
      'details': 'Reaching Rara requires a flight to Talcha Airport followed by a short trek, or a multi-day trek from Jumla. The best season to visit is May to October, as the region is snowbound in winter. There are no major facilities beyond basic teahouses, so travelers should plan supplies accordingly.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      'galleryImageUrls': [],
      'latitude': 29.5330, 'longitude': 82.0800, 'difficulty': 'Hard', 'estimatedBudgetNpr': 5000,
      'averageRating': 4.9, 'reviewCount': 1, 'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Swayambhunath Temple', 'categoryId': categoryIds['temples'], 'categoryName': 'Temples & Cultural Sites',
      'province': 'Bagmati',
      'shortDescription': 'The iconic hilltop stupa overlooking Kathmandu',
      'overview': 'Swayambhunath, widely known as the Monkey Temple, is one of the oldest and most sacred Buddhist sites in Nepal, believed to be over 1,500 years old. Perched atop a hill on the western edge of Kathmandu, its whitewashed stupa and painted Buddha eyes are visible from much of the valley below.',
      'details': 'Visitors can reach the top via a steep staircase of 365 steps or a winding road for those who prefer not to climb. The site is home to troops of resident monkeys, considered holy by local tradition. Early morning visits are quieter and offer good light for photography over the valley.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf',
      'galleryImageUrls': [],
      'latitude': 27.7149, 'longitude': 85.2903, 'difficulty': 'Easy', 'estimatedBudgetNpr': 200,
      'averageRating': 4.7, 'reviewCount': 6, 'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Pashupatinath Temple', 'categoryId': categoryIds['temples'], 'categoryName': 'Temples & Cultural Sites',
      'province': 'Bagmati',
      'shortDescription': 'A sacred Hindu temple complex on the Bagmati River',
      'overview': 'Pashupatinath is one of the most significant Hindu temple complexes in the world, dedicated to Lord Shiva and located on the banks of the Bagmati River. The complex includes the main pagoda-style temple, numerous smaller shrines, and cremation ghats where traditional Hindu funeral rites are still performed today.',
      'details': 'Non-Hindus are not permitted to enter the innermost temple but can view the complex and cremation ghats from across the river. Evening Aarti, a ritual of lamps and chanting performed by the riverbank, draws large crowds and is one of the most memorable times to visit.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1553912780-13f39a5cabdf',
      'galleryImageUrls': [],
      'latitude': 27.7106, 'longitude': 85.3487, 'difficulty': 'Easy', 'estimatedBudgetNpr': 200,
      'averageRating': 4.8, 'reviewCount': 5, 'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Phewa Lake Viewpoint', 'categoryId': categoryIds['viewpoints'], 'categoryName': 'Viewpoints',
      'province': 'Gandaki',
      'shortDescription': 'Sunrise views over Phewa Lake and the Annapurna range',
      'overview': 'This viewpoint above Pokhara offers one of the most complete panoramas in the region, combining the still waters of Phewa Lake in the foreground with the jagged Annapurna and Machhapuchhre peaks rising behind it. It is a favorite spot for both sunrise photography and quiet reflection.',
      'details': 'The viewpoint is accessible by a short taxi ride or a moderate uphill walk from the lakeside. Arriving before sunrise is recommended, as the peaks are most vivid in the golden morning light before clouds typically build up later in the day.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
      'galleryImageUrls': [],
      'latitude': 28.2096, 'longitude': 83.9310, 'difficulty': 'Easy', 'estimatedBudgetNpr': 300,
      'averageRating': 4.6, 'reviewCount': 4, 'isFeatured': true, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nagarkot Viewpoint', 'categoryId': categoryIds['viewpoints'], 'categoryName': 'Viewpoints',
      'province': 'Bagmati',
      'shortDescription': 'Panoramic Himalayan sunrise views near Kathmandu',
      'overview': 'Nagarkot is a hilltop village roughly two hours from Kathmandu, long regarded as one of the best places near the capital to watch the sun rise over the Himalayas. On a clear day, the view stretches from Dhaulagiri in the west to Everest in the east, making it a popular short getaway from the city.',
      'details': 'Most visitors stay overnight at one of the hillside guesthouses to catch the sunrise from a viewing tower just outside the village. Visibility is best during the dry months from October to March, while the monsoon season often brings heavy cloud cover that obscures the peaks.',
      'coverImageUrl': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
      'galleryImageUrls': [],
      'latitude': 27.7172, 'longitude': 85.5206, 'difficulty': 'Easy', 'estimatedBudgetNpr': 1000,
      'averageRating': 4.4, 'reviewCount': 3, 'isFeatured': false, 'approved': true, 'submittedBy': 'seed',
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  final destIds = <String>[];
  for (final d in destinations) {
    final doc = await firestore.collection('destinations').add(d);
    destIds.add(doc.id);
  }

  final reviews = [
    {'reviewerName': 'Anish', 'rating': 5, 'comment': 'Went early morning and the views were incredible, well worth the climb.'},
    {'reviewerName': 'Sabina', 'rating': 4, 'comment': 'Beautiful spot, just bring good shoes since parts of the trail get slippery.'},
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