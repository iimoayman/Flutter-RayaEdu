import 'package:flutter/material.dart';
import '../../../../data/datasources/local_datasource.dart';
import '../../../../domain/repositories/student_repository.dart';

enum SignInRole { student, professor, admin }

class SignInViewModel with ChangeNotifier {
  final StudentRepository repository;
  final LocalDataSource localDataSource;

  SignInRole _selectedRole = SignInRole.student;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isStudentApplied = false;

  SignInViewModel({
    required this.repository,
    required this.localDataSource,
  }) {
    _checkStudentApplied();
  }

  SignInRole get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isStudentApplied => _isStudentApplied;

  void setRole(SignInRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<void> _checkStudentApplied() async {
    _isStudentApplied = await localDataSource.isStudentApplied();
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await repository.signOut();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String userCode, String nationalId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.login(userCode, nationalId);
      _isLoading = false;
      if (res.success) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = res.errors?.firstOrNull ?? 'login_failed';
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
}
