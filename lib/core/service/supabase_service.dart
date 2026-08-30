import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://uxplbucgzotnixvbxtjc.supabase.co',
      anonKey: 'sb_publishable_9bmxo0vEc90SzikYHM_SDg_Py_4-Fyx',
    );
  }
}