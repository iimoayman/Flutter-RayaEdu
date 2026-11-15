import 'package:flutter/material.dart';
import '../../../../data/models/material_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class EduPortalViewModel with ChangeNotifier {
  final StudentRepository repository;

  int? _currentMaterialPk;
  String? _currentMaterialName;
  MainPortal? _mainPortal;
  int? _selectedChapterPk;
  bool _isLoading = false;
  String? _errorMessage;

  EduPortalViewModel(this.repository);

  int? get currentMaterialPk => _currentMaterialPk;
  String? get currentMaterialName => _currentMaterialName;
  MainPortal? get mainPortal => _mainPortal;
  int? get selectedChapterPk => _selectedChapterPk;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setMaterial(int pk, String name) {
    _currentMaterialPk = pk;
    _currentMaterialName = name;
    _selectedChapterPk = null;
    loadChapterData(materialPk: pk);
  }

  void selectChapter(int chapterPk) {
    _selectedChapterPk = chapterPk;
    loadChapterData(materialPk: _currentMaterialPk, chapterPk: chapterPk);
  }

  Future<void> loadChapterData({int? materialPk, int? chapterPk}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.getChapterData(
        openMaterialPk: materialPk,
        chapterPk: chapterPk,
      );
      if (res.success && res.data != null) {
        _mainPortal = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> completeUnit() async {
    if (_currentMaterialPk == null || _selectedChapterPk == null) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final res = await repository.endUnit(
        openMaterialPk: _currentMaterialPk!,
        chapterPk: _selectedChapterPk!,
      );
      _isLoading = false;
      notifyListeners();
      return res.success;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
