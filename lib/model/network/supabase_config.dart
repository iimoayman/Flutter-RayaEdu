class SupabaseConfig {
  SupabaseConfig._();

  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndwZ2dlcXh4eWVoc213dHVkdmF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyMzMzMTgsImV4cCI6MjA4MzgwOTMxOH0.yZTDrib5XB6SKUFX2eL3gQQNqtgvoGZM5pIETThXTpg';

  static const String baseUrl = 'https://wpggeqxxyehsmwtudvax.supabase.co/';

  static Map<String, String> get headers => {
    'apikey': anonKey,
    'Authorization': 'Bearer $anonKey',
  };
}