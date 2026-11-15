import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/security/security_service.dart';
import 'core/utils/locale_provider.dart';
import 'core/utils/text_scale_provider.dart';
import 'data/datasources/local_datasource.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/datasources/supabase_datasource.dart';
import 'data/repositories_impl/student_repository_impl.dart';
import 'domain/repositories/student_repository.dart';
import 'presentation/features/admission/viewmodel/admission_viewmodel.dart';
import 'presentation/features/auth/viewmodel/sign_in_viewmodel.dart';
import 'presentation/features/digital_id/viewmodel/digital_id_viewmodel.dart';
import 'presentation/features/edu_portal/viewmodel/edu_portal_viewmodel.dart';
import 'presentation/features/edu_portal/viewmodel/exam_viewmodel.dart';
import 'presentation/features/guest/viewmodel/guest_viewmodel.dart';
import 'presentation/features/home/viewmodel/home_viewmodel.dart';
import 'presentation/features/home/viewmodel/notifications_viewmodel.dart';
import 'presentation/features/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'presentation/features/results_records/viewmodel/results_records_viewmodel.dart';
import 'presentation/features/settings/viewmodel/settings_viewmodel.dart';
import 'presentation/features/splash/viewmodel/splash_viewmodel.dart';
import 'presentation/features/student_services/viewmodel/student_services_viewmodel.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/navigation/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase safely
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Allows local testing without google-services.json
  }

  // Portrait orientation lock mirroring AndroidManifest.xml
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System UI Overlay styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.mainC,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Enable screenshot prevention & data leakage protection
  await SecurityService.enableScreenProtection();

  // Initialize Local Storage & Data Sources
  final localDataSource = LocalDataSource();
  await localDataSource.init();

  final apiClient = ApiClient(localDataSource);
  final remoteDataSource = RemoteDataSource(apiClient);
  final supabaseDataSource = SupabaseDataSource(apiClient);

  final StudentRepository studentRepository = StudentRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    supabaseDataSource: supabaseDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(localDataSource)),
        ChangeNotifierProvider(create: (_) => TextScaleProvider(localDataSource)),
        ChangeNotifierProvider(create: (_) => SettingsViewModel(localDataSource)),
        ChangeNotifierProvider(create: (_) => SplashViewModel(localDataSource)),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel(localDataSource)),
        ChangeNotifierProvider(
          create: (_) => SignInViewModel(
            repository: studentRepository,
            localDataSource: localDataSource,
          ),
        ),
        ChangeNotifierProvider(create: (_) => GuestViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => HomeViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => NotificationsViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => DigitalIdViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => EduPortalViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => ExamViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => StudentServicesViewModel(studentRepository)),
        ChangeNotifierProvider(create: (_) => ResultsRecordsViewModel(studentRepository)),
        ChangeNotifierProvider(
          create: (_) => AdmissionViewModel(
            repository: studentRepository,
            localDataSource: localDataSource,
          ),
        ),
      ],
      child: const RayaEduApp(),
    ),
  );
}

class RayaEduApp extends StatelessWidget {
  const RayaEduApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final textScaleProvider = context.watch<TextScaleProvider>();
    final settingsVm = context.watch<SettingsViewModel>();

    final primaryColor = settingsVm.isBlueAccent ? AppColors.blue : AppColors.mainC;

    return MaterialApp(
      title: 'Raya Higher Institute',
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme(primaryColor: primaryColor),
      darkTheme: AppTheme.darkTheme(primaryColor: primaryColor),
      themeMode: settingsVm.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleProvider.scale),
          ),
          child: Directionality(
            textDirection: localeProvider.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
