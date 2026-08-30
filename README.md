# GhumNepal

GhumNepal is a tourism app for discovering destinations across Nepal — hikes, temples and cultural sites, lakes, and viewpoints. Users can browse and search destinations, save places to a wishlist, and submit new destinations for admins to review and approve. Admins can manage categories, approve or reject submissions, and edit destination details.

Built with Flutter, so it runs as a mobile app (Android/iOS) and a web app from the same codebase.

## How to run it

1. **Install Flutter.** If you don't already have it, follow the official guide: https://docs.flutter.dev/get-started/install

2. **Get the project dependencies.** From the project root:

flutter pub get

3. **Firebase and Supabase are already configured.** This repo ships with working Firebase (`lib/firebase_options.dart`, `android/app/google-services.json`) and Supabase credentials already in place, so you don't need to set up your own project to run the app. Note that this means anyone who runs this project connects to the same shared Firebase/Firestore database and Supabase storage bucket as everyone else running it — any account created, destination submitted, or photo uploaded goes into that same live data.

4. **Run the app.**

flutter run

This launches on whatever device/emulator/browser you have selected. Use `flutter devices` to see your options, or pass `-d chrome` to run it in a browser.

## Technologies used

- **Flutter / Dart** — app framework, one codebase for mobile and web
- **Firebase Authentication** — email/password and Google sign-in
- **Cloud Firestore** — database for destinations, categories, users, reviews, and wishlists
- **Supabase Storage** — hosts uploaded images (destination photos, profile pictures, category images)
- **Provider** — state management
- **flutter_map** + **latlong2** — interactive maps for destination locations
- **geolocator** — device location access
- **image_picker** — selecting photos to upload
- **cached_network_image** — image loading and caching
- **hive** / **hive_flutter** — local on-device storage/caching
- **google_fonts** — custom typography