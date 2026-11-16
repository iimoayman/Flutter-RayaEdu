import 'package:flutter/material.dart';
import '../../../../data/models/material_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class ExamViewModel with ChangeNotifier {
  final StudentRepository repository;

  ExamChapter? _currentExam;
  int? _chapterPk;
  final Map<int, String> _selectedAnswers = {};
  bool _confirmOne = false;
  bool _confirmTwo = false;
  bool _isSubmitting = false;

  ExamViewModel(this.repository);

  ExamChapter? get currentExam => _currentExam;
  Map<int, String> get selectedAnswers => _selectedAnswers;
  bool get confirmOne => _confirmOne;
  bool get confirmTwo => _confirmTwo;
  bool get isSubmitting => _isSubmitting;
  bool get isAlreadySubmitted => _currentExam?.foundAnswers ?? false;
  bool get canSubmit =>
      !isAlreadySubmitted && _confirmOne && _confirmTwo && !_isSubmitting;

  void setExam(ExamChapter exam, int chapterPk) {
    _currentExam = exam;
    _chapterPk = chapterPk;
    _selectedAnswers.clear();
    _confirmOne = false;
    _confirmTwo = false;
    notifyListeners();
  }

  void selectAnswer(int questionPk, String optionKey) {
    if (isAlreadySubmitted) return;
    _selectedAnswers[questionPk] = optionKey;
    notifyListeners();
  }

  void toggleConfirmOne(bool val) {
    if (isAlreadySubmitted) return;
    _confirmOne = val;
    notifyListeners();
  }

  void toggleConfirmTwo(bool val) {
    if (isAlreadySubmitted) return;
    _confirmTwo = val;
    notifyListeners();
  }

  Future<bool> submitExam() async {
    if (isAlreadySubmitted || _chapterPk == null) return false;
    _isSubmitting = true;
    notifyListeners();

    try {
      final res = await repository.submitAnswers(
        chapterPk: _chapterPk!,
        answers: _selectedAnswers,
      );
      if (res.success && _currentExam != null) {
        // Lock this exam immediately to prevent any duplicate submissions
        _currentExam = ExamChapter(
          pk: _currentExam!.pk,
          name: _currentExam!.name,
          questions: _currentExam!.questions,
          foundAnswers: true,
        );
      }
      _isSubmitting = false;
      notifyListeners();
      return res.success;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
