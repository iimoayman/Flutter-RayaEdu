import 'package:flutter/material.dart';
import '../../../../data/datasources/local_datasource.dart';

class OnboardingItemModel {
  final IconData icon;
  final String titleKey;
  final String bodyKey;

  OnboardingItemModel({
    required this.icon,
    required this.titleKey,
    required this.bodyKey,
  });
}

class OnboardingViewModel with ChangeNotifier {
  final LocalDataSource localDataSource;

  int _currentPage = 0;

  OnboardingViewModel(this.localDataSource);

  int get currentPage => _currentPage;

  final List<OnboardingItemModel> slides = [
    OnboardingItemModel(
      icon: Icons.school_rounded,
      titleKey: 'onboarding_title_1',
      bodyKey: 'onboarding_text_1',
    ),
    OnboardingItemModel(
      icon: Icons.business_center_rounded,
      titleKey: 'onboarding_title_2',
      bodyKey: 'onboarding_text_2',
    ),
    OnboardingItemModel(
      icon: Icons.workspace_premium_rounded,
      titleKey: 'onboarding_title_3',
      bodyKey: 'onboarding_text_3',
    ),
  ];

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await localDataSource.markFirstOpenDone();
  }
}
