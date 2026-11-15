import 'package:flutter/material.dart';
import '../../../../data/models/service_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class StudentServicesViewModel with ChangeNotifier {
  final StudentRepository repository;

  List<StuServices> _servicesHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  StudentServicesViewModel(this.repository) {
    loadServiceHistory();
  }

  List<StuServices> get servicesHistory => _servicesHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadServiceHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.getServiceHistory();
      if (res.success && res.data != null) {
        _servicesHistory = res.data!;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitService({
    required String serviceType,
    required String addressed,
    required String notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await repository.addService(
        serviceType: serviceType,
        addressed: addressed,
        notesStudent: notes,
      );
      _isLoading = false;
      if (res.success) {
        await loadServiceHistory();
        return true;
      }
      return false;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
