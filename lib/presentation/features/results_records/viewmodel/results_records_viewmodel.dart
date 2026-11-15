import 'package:flutter/material.dart';
import '../../../../data/models/exam_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class ResultsRecordsViewModel with ChangeNotifier {
  final StudentRepository repository;

  ResultsResponse? _resultsResponse;
  List<ExamResultDto> _onlineResults = [];
  List<ExamInfo> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  ResultsRecordsViewModel(this.repository);

  ResultsResponse? get resultsResponse => _resultsResponse;
  List<ExamResultDto> get onlineResults => _onlineResults;
  List<ExamInfo> get records => _records;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadResults() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.getResults();
      if (res.success && res.data != null) {
        _resultsResponse = res.data;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOnlineResults() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.getOnlineResults();
      if (res.success && res.data != null) {
        _onlineResults = res.data!;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecords() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await repository.getRecords();
      if (res.success && res.data != null) {
        _records = res.data!;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
