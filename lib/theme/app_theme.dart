import 'package:flutter/material.dart';
import 'package:rayaedu/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.mainC,
    fontFamily: 'Cairo',                    // ← GLOBAL FONT
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.mainC,
      secondary: AppColors.orange,
    ),

    // Force the font on every sub-theme too, so widgets that override
    // TextStyle internally still respect Cairo.
    textTheme: const TextTheme(
      bodyLarge:  TextStyle(fontFamily: 'Cairo'),
      bodyMedium: TextStyle(fontFamily: 'Cairo'),
      bodySmall:  TextStyle(fontFamily: 'Cairo'),
      titleLarge: TextStyle(fontFamily: 'Cairo'),
      titleMedium: TextStyle(fontFamily: 'Cairo'),
      titleSmall: TextStyle(fontFamily: 'Cairo'),
      labelLarge: TextStyle(fontFamily: 'Cairo'),
      labelMedium: TextStyle(fontFamily: 'Cairo'),
      labelSmall: TextStyle(fontFamily: 'Cairo'),
    ),

    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        color: AppColors.white,
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.mainC,
      unselectedLabelColor: AppColors.mainC,
      indicatorColor: AppColors.mainC,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w800),
      unselectedLabelStyle:
      TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontFamily: 'Cairo'),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontFamily: 'Cairo'),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(fontFamily: 'Cairo'),
      hintStyle: TextStyle(fontFamily: 'Cairo'),
    ),

    dialogTheme: const DialogThemeData(
      titleTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 20),
      contentTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 15),
    ),
  );
}