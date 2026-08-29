import 'package:flutter/material.dart';
import 'core/service/firebase_service.dart';
import 'core/service/supabase_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Text(
            'ERROR:\n${details.exceptionAsString()}\n\n${details.stack}',
            style: const TextStyle(color: Colors.red, fontSize: 11),
          ),
        ),
      ),
    );
  };

  await FirebaseService.initialize();
  await SupabaseService.initialize();

  runApp(const GhumNepalApp());
}