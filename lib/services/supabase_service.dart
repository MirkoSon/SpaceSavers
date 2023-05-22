import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _singleton = SupabaseService._internal();
  late SupabaseClient client;
  static const String supabaseUrl = 'https://qwtyrzzptgfkgezhahwb.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3dHlyenpwdGdma2dlemhhaHdiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQzMTYwMjksImV4cCI6MTk5OTg5MjAyOX0.04tjEAp7BZBXuIiR5ohEAgQCYkGnnlcORRFelvGOcZE';

  factory SupabaseService() {
    return _singleton;
  }

  SupabaseService._internal() {
    client = SupabaseClient(supabaseUrl, supabaseKey);
  }
}
