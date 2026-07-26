import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/destination_repository.dart';
import 'data/repositories/wishlist_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/destination_provider.dart';
import 'presentation/providers/wishlist_provider.dart';
import 'presentation/providers/admin_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home_feed/home_feed_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/admin/admin_panel_screen.dart';
import 'data/repositories/category_repository.dart';
import 'presentation/providers/category_provider.dart';

class GhumNepalApp extends StatelessWidget {
  const GhumNepalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => DestinationRepository()),
        Provider(create: (_) => WishlistRepository()),
        Provider(create: (_) => CategoryRepository()),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(context.read<CategoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DestinationProvider(context.read<DestinationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              WishlistProvider(context.read<WishlistRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AdminProvider(context.read<DestinationRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'GhumNepal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeFeedScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/admin': (context) => const AdminPanelScreen(),
        },
      ),
    );
  }
}