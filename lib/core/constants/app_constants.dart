class AppConstants {
  AppConstants._();

  // Firestore collections
  static const String usersCollection = 'users';
  static const String destinationsCollection = 'destinations';
  static const String categoriesCollection = 'categories';
  static const String reviewsCollection = 'reviews';
  static const String wishlistSubcollection = 'wishlist';

  // Supabase
  static const String mediaBucket = 'media';

  // Nepal's 7 provinces, used for the Discover feed's Province filter
  static const List<String> nepalProvinces = [
    'Koshi',
    'Madhesh',
    'Bagmati',
    'Gandaki',
    'Lumbini',
    'Karnali',
    'Sudurpashchim',
  ];
}