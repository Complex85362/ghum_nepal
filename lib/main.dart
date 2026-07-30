import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://uxplbucgzotnixvbxtjc.supabase.co',
    publishableKey: 'sb_publishable_9bmxo0vEc90SzikYHM_SDg_Py_4-Fyx',
  );
  runApp(const GhumNepalApp());
}