import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.mainC,
    fontFamily: 'CairoExtraBold',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.mainC,
      secondary: AppColors.orange,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.mainC,
      unselectedLabelColor: AppColors.white,
      indicatorColor: AppColors.orange,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14),
    ),
  );
}

const TextStyle navDrawerTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: AppColors.navIcons,
);

final ShapeBorder circleImage = const CircleBorder();