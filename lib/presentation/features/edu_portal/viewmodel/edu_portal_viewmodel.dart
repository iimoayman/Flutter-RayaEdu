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
  String? _unitEndErrorMessage;

  EduPortalViewModel(this.repository);

  int? get currentMaterialPk => _currentMaterialPk;
  String? get currentMaterialName => _currentMaterialName;
  MainPortal? get mainPortal => _mainPortal;
  int? get selectedChapterPk => _selectedChapterPk;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get unitEndErrorMessage => _unitEndErrorMessage;

  bool get isCurrentChapterCompleted {
    if (_mainPortal == null) return false;
    final activePk = _selectedChapterPk ?? _mainPortal!.chapterData.pk;
    if (activePk == null) {
      if (_mainPortal!.chapters.isNotEmpty) {
        return _mainPortal!.chapters.first.complete;
      }
      return false;
    }
    final match = _mainPortal!.chapters.where((c) => c.pk == activePk).firstOrNull;
    if (match != null) return match.complete;
    return _mainPortal!.chapterData.complete ?? false;
  }

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
    final activePk = _selectedChapterPk ??
        _mainPortal?.chapterData.pk ??
        (_mainPortal?.chapters.isNotEmpty == true ? _mainPortal!.chapters.first.pk : null);

    if (_currentMaterialPk == null || activePk == null) return false;
    if (isCurrentChapterCompleted) return true;

    _unitEndErrorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final res = await repository.endUnit(
        openMaterialPk: _currentMaterialPk!,
        chapterPk: activePk,
      );
      if (res.success && _mainPortal != null) {
        final updatedChapters = _mainPortal!.chapters.map((c) {
          if (c.pk == activePk) {
            return Chapter(pk: c.pk, name: c.name, complete: true);
          }
          return c;
        }).toList();
        _mainPortal = MainPortal(
          chapters: updatedChapters,
          chapterData: _mainPortal!.chapterData,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorText = res.errors?.firstOrNull;
        if (errorText == null ||
            errorText.contains('ايقاف') ||
            errorText.contains('إيقاف') ||
            errorText.contains('stopped') ||
            errorText.isEmpty) {
          _unitEndErrorMessage = 'غير مسموح لتجاوز المدة';
        } else {
          _unitEndErrorMessage = errorText;
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (_) {
      _unitEndErrorMessage = 'غير مسموح لتجاوز المدة';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
