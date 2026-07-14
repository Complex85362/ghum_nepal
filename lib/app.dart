import 'package:flutter/material.dart';
import 'package:ghum_nepal/presentation/providers/destination_provider.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/destination_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/login_screen.dart';

class GhumNepalApp extends StatelessWidget {
  const GhumNepalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DestinationRepository()),
        ChangeNotifierProvider(
          create: (context) => DestinationProvider(context.read<DestinationRepository>()),
        ),
        Provider(create: (_) => AuthRepository()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'GhumNepal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );
  }
}