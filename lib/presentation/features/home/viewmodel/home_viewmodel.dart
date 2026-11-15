import 'package:flutter/material.dart';
import '../../../../data/models/material_models.dart';
import '../../../../data/models/student_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class HomeViewModel with ChangeNotifier {
  final StudentRepository repository;

  MyData? _studentData;
  StudentAchievements? _achievements;
  List<StudyMaterials> _materials = [];
  List<Order> _banners = [];
  List<HuaweiSession> _huaweiSessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  HomeViewModel(this.repository) {
    loadHomeData();
  }

  MyData? get studentData => _studentData;
  StudentAchievements? get achievements => _achievements;
  List<StudyMaterials> get materials => _materials;
  List<Order> get banners => _banners;
  List<HuaweiSession> get huaweiSessions => _huaweiSessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        repository.getMyData(),
        repository.getMyAchievements(),
        repository.getMyMaterials(),
        repository.getRayaBanners(),
        repository.getHuaweiSessions(),
      ]);

      final myDataRes = futures[0] as dynamic;
      final achievementsRes = futures[1] as dynamic;
      final materialsRes = futures[2] as dynamic;
      final bannersRes = futures[3] as List<Order>;
      final huaweiRes = futures[4] as List<HuaweiSession>;

      if (myDataRes.success && myDataRes.data != null) {
        _studentData = myDataRes.data;
      }
      if (achievementsRes.success && achievementsRes.data != null) {
        _achievements = achievementsRes.data;
      }
      if (materialsRes.success && materialsRes.data != null) {
        _materials = materialsRes.data;
      }
      _banners = bannersRes;
      _huaweiSessions = huaweiRes;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
