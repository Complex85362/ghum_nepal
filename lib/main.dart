import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://uxplbucgzotnixvbxtjc.supabase.co/rest/v1/',
    publishableKey: 'sb_publishable_9bmxo0vEc90SzikYHM_SDg_Py_4-Fyx',
  );
  runApp(const GhumNepalApp());
}