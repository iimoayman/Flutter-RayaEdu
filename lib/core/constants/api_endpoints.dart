class ApiEndpoints {
  static const String studentGateBaseUrl = 'https://gatestudent.rayaedu.org/studentgate/';
  static const String studentGateReferer = 'https://gatestudent.rayaedu.org/';
  static const String adminBaseUrl = 'https://student.rayaedu.org/';
  static const String supabaseBaseUrl = 'https://wpggeqxxyehsmwtudvax.supabase.co/';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndwZ2dlcXh4eWVoc213dHVkdmF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyMzMzMTgsImV4cCI6MjA4MzgwOTMxOH0.yZTDrib5XB6SKUFX2eL3gQQNqtgvoGZM5pIETThXTpg';

  // Student Gate Endpoints
  static const String login = 'login/';
  static const String app = 'app/';
  static const String applyContinue = 'admission/continue/';
  static const String applyData = 'admission/data/';
  static const String applyAdmission = 'admission/admission/';
  static const String applyLookups = 'admission/lookups/';

  // Admin Endpoints
  static const String adminLogin = 'cpanel/admin/login/';

  // Supabase Endpoints
  static const String rayaBanners = 'rest/v1/RayaBanners';
  static const String guestBanners = 'rest/v1/Guest';
  static const String guestBannersSecond = 'rest/v1/BanGuest';
  static const String huaweiSessions = 'rest/v1/HuaweiSessions';
}
