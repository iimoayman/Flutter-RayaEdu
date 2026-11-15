import 'package:flutter/material.dart';
import '../../../../data/datasources/local_datasource.dart';
import '../../../../data/models/admission_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class AdmissionViewModel with ChangeNotifier {
  final StudentRepository repository;
  final LocalDataSource localDataSource;

  OptionsData? _optionsData;
  bool _isLoading = false;
  String? _errorMessage;
  String? _resumeToken;

  AdmissionViewModel({
    required this.repository,
    required this.localDataSource,
  }) {
    loadLookups();
  }

  OptionsData? get optionsData => _optionsData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadLookups() async {
    try {
      final res = await repository.getAdmissionLookups();
      if (res.success) {
        _optionsData = res.data;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> applyContinue({
    required String phone,
    required String identifier,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.applyContinue(
        phone: phone,
        identifier: identifier,
      );
      _isLoading = false;

      if (res.success && res.data?.resumeToken != null) {
        _resumeToken = res.data!.resumeToken;
        await localDataSource.saveResumeToken(_resumeToken!);
        notifyListeners();
        return true;
      } else {
        _errorMessage = res.errors.firstOrNull ?? 'فشل التحقق من البيانات';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitDataOne(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = _resumeToken ?? (await localDataSource.getResumeToken()) ?? '';
      data['resume_token'] = token;

      final success = await repository.fillDataOne(data);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitDataTwo(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = _resumeToken ?? (await localDataSource.getResumeToken()) ?? '';
      data['resume_token'] = token;

      final success = await repository.fillDataTwo(data);
      _isLoading = false;
      if (success) {
        await localDataSource.setStudentApplied();
        await localDataSource.clearResumeToken();
      }
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
